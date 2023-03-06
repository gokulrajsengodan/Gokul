public without sharing class EmailMessageCtrl {
    
    @AuraEnabled(cacheable=true)
    public static DataWrapper getEmailTempaltes() {
        Email_Configuration__mdt cmd = Email_Configuration__mdt.getInstance('Candidate_Email_Folder_Names');
        List<String> emailFolderNames = cmd.Value__c.contains(',')? cmd.Value__c.split(','): new List<String>{cmd.Value__c};
            
        List<EmailTemplates> emailTemplatelist = new List<EmailTemplates>();
        List<Folder> folderList = new List<Folder>();
        folderList = [
            SELECT Id, Name
            FROM Folder
            WHERE Name IN:emailFolderNames
        ];
        for (sobject emailtemp : [
            SELECT Id, FolderId, HtmlValue, FolderName, isActive, body, Name, subject
            FROM EmailTemplate
            WHERE isActive = true AND FolderId IN :folderList
        ]) {
            EmailTemplates template = new EmailTemplates();
            template.emailTemplateId = String.valueOf(emailtemp.get('Id'));
            template.emailTemplatename = String.valueOf(emailtemp.get('Name'));
            template.emailbody = (emailtemp.get('HtmlValue') != null
                                  ? String.valueOf(emailtemp.get('HtmlValue'))
                                  : '');
            template.emailSubject = String.valueOf(emailtemp.get('subject'));
            emailTemplatelist.add(template);
        }
        
        List<OrgWideEmailAddress> orgWideAddressList = [SELECT Id,Address FROM OrgWideEmailAddress];
        List<PicklistOption> fromAddressList = new List<PicklistOption>();
        
        PicklistOption currentUsrFrmAdd = new PicklistOption();
        currentUsrFrmAdd.Label = UserInfo.getUserEmail();
        currentUsrFrmAdd.value = 'Current User';
        fromAddressList.add(currentUsrFrmAdd);
        
        for(OrgWideEmailAddress owa:orgWideAddressList){
            PicklistOption fa = new PicklistOption();
            fa.Label = owa.Address;
            fa.value = owa.Address;
            fromAddressList.add(fa);
        }
        
        DataWrapper data = new DataWrapper();
        data.emailTemplateList = emailTemplatelist;
        data.fromAddressOptions = fromAddressList;
        
        return data;
    }
    
    @AuraEnabled
    public static string sendMailMethod(
        String selectedRecordStr,
        String subject,
        String emailbody,
        String templateId,
        String ccAddress,
        String fromAddress
    ) {
        List<RecordWrapper> selectedRecords = (List<RecordWrapper>)JSON.deserialize(selectedRecordStr, List<RecordWrapper>.class);
        if(selectedRecords.size()>1){
            try {
                
                EmailMessageCtrlBatch batch = new EmailMessageCtrlBatch(selectedRecords,subject,emailbody,ccAddress,fromAddress);
                if(Test.isRunningTest()){
                    Database.executeBatch(batch,200);
                } else {
                    System.debug('Batch excu:: ');
                    Database.executeBatch(batch,10);
                }
            } catch (Exception ex) {
                return ex.getMessage();
            }
            return null;
        }
        
        else{
            List<String> sendTo = new List<String>();
            sendTo.add(selectedRecords[0].email);
            
            string htmlReplace = '';
            if (emailbody != null && emailbody != '') {
                htmlReplace = emailbody;
            }
            
            if (
                htmlReplace != null &&
                htmlReplace.containsIgnoreCase('{!Name}')
            ) {
                htmlReplace =
                    htmlReplace.replace('{!Name}', selectedRecords[0].name != null ? selectedRecords[0].name : selectedRecords[0].email);
            }    
            
            EmailSender.EmailRequest emailReq = new EmailSender.EmailRequest();
            if(String.isNotBlank(fromAddress) && fromAddress != 'Current User'){
                emailReq.fromOWDAddress = fromAddress;
            }
            emailReq.htmlBody = htmlReplace;
            emailReq.Subject = subject;
            emailReq.whatId = selectedRecords[0].recordId;
            emailReq.toAddressesList = sendTo;
            if(String.isNotBlank(ccAddress)){
                List<String> ccAddressList = new List<String>();
                
                if(ccAddress.contains(',')){
                    ccAddressList.addAll(ccAddress.split(','));
                } else{
                    ccAddressList.add(ccAddress);
                }
                
                emailReq.ccAddressesList = ccAddressList;

            }
            EmailSender.sendEmail(new List<EmailSender.EmailRequest>{emailReq});
            return null;
        }
    }
    
    
    public class emailTemplates {
        @AuraEnabled
        public String emailTemplateId;
        @AuraEnabled   
        public String emailbody;
        @AuraEnabled
        public String emailSubject;
        @AuraEnabled
        public String emailTemplatename;
    }
    public class DataWrapper {
        @AuraEnabled
        public list<EmailTemplates> emailTemplateList {get; set;}
        @AuraEnabled
        public List<PicklistOption> fromAddressOptions {get; set;}
    }
    
    public class PicklistOption {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
    }
    
    public class RecordWrapper{
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String recordId;
        @AuraEnabled
        public String email;
    }
}
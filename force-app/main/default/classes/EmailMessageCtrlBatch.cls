public class EmailMessageCtrlBatch implements Database.Batchable<EmailMessageCtrl.RecordWrapper>, Database.Stateful {
    List<EmailMessageCtrl.RecordWrapper> accList;
    String subject;
    String emailbody;
    String ccAddress;
    String fromAddress;
    //String templateId;
    
    public EmailMessageCtrlBatch(List<EmailMessageCtrl.RecordWrapper> accList, String subject, String emailbody,String ccAddress,String fromAddress) {
        this.accList = accList;
        this.subject = subject;
        this.emailbody = emailbody;
        this.ccAddress = ccAddress;
        this.fromAddress = fromAddress;
        //this.templateId = templateId;
        system.debug('accList ::--->'+this.accList);
        system.debug('Inside Apex Class');
    }
    
    public List<EmailMessageCtrl.RecordWrapper> start(Database.BatchableContext BC) {
        system.debug('Inside Start Method-');
        return accList;
    }
    
    public void execute(Database.BatchableContext BC, List<EmailMessageCtrl.RecordWrapper> scope) {
        
        List<EmailSender.EmailRequest> emailReqList = new List<EmailSender.EmailRequest>();
        
        for (EmailMessageCtrl.RecordWrapper rec : scope) {
            system.debug('T-Inside For Loop-'+rec.name);
            List<String> sendTo = new List<String>();
            sendTo.add(rec.email);
            
            string htmlReplace = '';
            if (emailbody != null && emailbody != '') {
                htmlReplace = emailbody;
            }
            
            if (
                htmlReplace != null &&
                htmlReplace.containsIgnoreCase('{!Name}')
            ) {
                htmlReplace =
                    htmlReplace.replace('{!Name}', rec.name != null ? rec.name : rec.email);
            }
            EmailSender.EmailRequest emailReq = new EmailSender.EmailRequest();
            if(String.isNotBlank(fromAddress) && fromAddress != 'Current User'){
                emailReq.fromOWDAddress = fromAddress;
            }
            emailReq.htmlBody = htmlReplace;
            emailReq.Subject = subject;
            emailReq.whatId = rec.recordId;
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
            emailReqList.add(emailReq);
        }
        if(emailReqList.size() > 0){
            
            EmailSender.sendEmail(emailReqList);
        }
    }   
    
    public void finish(Database.BatchableContext BC) {
    }
}
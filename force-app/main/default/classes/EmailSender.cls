public class EmailSender {
    
    @InvocableMethod(Label='EmailSender')
    public static void sendEmail(List<EmailRequest> mailRequest)
    {
        Map<String,Id> orgWideMap=New map<String,Id>();
        set<String> orgWideEmailSet=new set<String>();
        for(EmailRequest em:mailRequest)
        {
            if(string.isNotBlank(em.fromOWDAddress))
            {
                orgWideEmailSet.add(em.fromOWDAddress);
            }
        }
        List<OrgWideEmailAddress> oweList = [select id, Address, DisplayName from OrgWideEmailAddress where Address in:orgWideEmailSet];
        for(OrgWideEmailAddress ow:oweList)
        {
            orgWideMap.put(ow.Address,ow.Id);
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(EmailRequest requests:mailRequest){
            List<String> toAddList =new List<String>();
            List<String> toCcList =new List<String>();
            List<String> toBccList =new List<String>();
            if(requests.toAddressesList !=null && requests.toAddressesList.size()>0)
            {
                set<string> toAddressesSet = new set<string>(requests.toAddressesList);
                toAddressesSet.remove('');
                toAddressesSet.remove(null);
                requests.toAddressesList = new list<string>(toAddressesSet);
                toAddList.addall(requests.toAddressesList);
                
            }
            if(string.isNotBlank(requests.toAddresses))
            {
                toAddList=requests.toAddresses.split(',');
            }
            if(requests.ccAddressesList !=null && requests.ccAddressesList.size()>0)
            {
                set<string> ccAddressesSet = new set<string>(requests.ccAddressesList);
                ccAddressesSet.remove('');
                ccAddressesSet.remove(null);
                requests.ccAddressesList = new list<string>(ccAddressesSet);
                toCcList.addall(requests.ccAddressesList);                
            }
            if(string.isNotBlank(requests.ccAddresses))
            {
                toCcList=requests.ccAddresses.split(',');   
            }
            if(requests.bccAddressesList!=null && requests.bccAddressesList.size()>0)
            {
                set<string> bccAddressesSet = new set<string>(requests.bccAddressesList);
                bccAddressesSet.remove('');
                bccAddressesSet.remove(null);
                requests.bccAddressesList = new list<string>(bccAddressesSet);
                toBccList.addall(requests.bccAddressesList);
            }
            if(string.isNotBlank(requests.bccAddresses))
            {
                toBccList=requests.bccAddresses.split(',');   
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(String.isNotBlank(requests.fromOWDAddress) && orgWideMap.containskey(requests.fromOWDAddress)) 
            {
                mail.setOrgWideEmailAddressId(orgWideMap.get(requests.fromOWDAddress));   
            }
      /*      if(String.isNotBlank(requests.invoiceIdForPDFAttachment))
            {
                PageReference pdf =  Page.InvoicePDFGenerationPage;
                pdf.getParameters().put('id',requests.invoiceIdForPDFAttachment);
                Blob b = pdf.getContentAsPDF();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setContentType('application/pdf');
                efa.setFileName('Invoice.pdf');
                efa.setInline(false);
                efa.setBody(b);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            }     */
            if(string.isNotBlank(requests.toAddress))
            {                
                toAddList.add(requests.toAddress);
            }
            
            mail.setToAddresses(toAddList);
            if(string.isNotBlank(requests.ccAddress))
            {                
                toCcList.add(requests.ccAddress);
            }
            mail.setCcAddresses(toCcList);
            if(string.isNotBlank(requests.bccAddress))
            {                
                toBccList.add(requests.bccAddress);
            }
            mail.setBccAddresses(toBccList);
            mail.setHtmlBody(requests.htmlBody);
            if(String.isNotBlank(requests.textBody)) 
            {
                mail.setPlainTextBody(requests.textBody);   
            }
            mail.setSubject(requests.Subject);
            if(String.isNotBlank(requests.replyTo))
            {
                mail.setReplyTo(requests.replyTo); 
            }
            if(String.isNotBlank(requests.ReplyToIncomingEmail))
            {
                mail.setReplyTo(requests.ReplyToIncomingEmail); 
            }
            mail.setWhatId(requests.whatId);
            mail.setSaveAsActivity(True);
            mails.add(mail);
        }
        if (mails.size() > 0) {
            Messaging.sendEmail(mails);
        }
        
    }
    
    public class EmailRequest{
        
        @InvocableVariable(label='FromOWDAddress')
        public String fromOWDAddress;
        @InvocableVariable(label='ToAddresses(List)')
        public List<String> toAddressesList;
        @InvocableVariable(label='ToAddress')
        public String toAddress;
        @InvocableVariable(label='ToAddresses(Comma Separated)')
        public String toAddresses;
        @InvocableVariable(label='CcAddresses(List)')
        public list<String> ccAddressesList;
        @InvocableVariable(label='CcAddresses(Comma Separated)')
        public String ccAddresses;
        @InvocableVariable(label='CcAddress')
        public String ccAddress;
        @InvocableVariable(label='BccAddresses(List)')
        public List<String> bccAddressesList;
        @InvocableVariable(label='BccAddress')
        public String bccAddress;
        @InvocableVariable(label='BccAddresses(Comma Separated)')
        public String bccAddresses;
        @InvocableVariable(label='HtmlBody')
        public String htmlBody;
        @InvocableVariable(label='TextBody')
        public String textBody;
        @InvocableVariable(label='Subject')
        public String Subject;
        @InvocableVariable(label='ReplyTo')
        public String replyTo;
        @InvocableVariable(label='WhatId')
        public Id whatId;
        @InvocableVariable(label='Reply To Incoming Email')   
        public string ReplyToIncomingEmail;
        @InvocableVariable(label='InvoiceIdForPDFAttachment')
        public String invoiceIdForPDFAttachment;
    }
    
    
}
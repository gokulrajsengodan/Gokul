global class UnsubscribeContact implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult  handleInboundEmail(Messaging.inboundEmail email, 
                                                            Messaging.InboundEnvelope env)
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        Contact con = new Contact();
        List<Contact> conList = [SELECT Id,Name,Email FROM Contact WHERE Email = :email.fromAddress];
        if(conList.size() > 0){
            con.Unsubscribe__c = TRUE;
            con.Id = conList[0].id;
            con.Description = email.plainTextBody;
            Update con;
        }
        result.success = true;
        
        return result;
    }
}
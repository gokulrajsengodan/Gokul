public class LeadTriggerHandler {
    
    public void createContact(list<lead> leadList){
      //  list<contact>conList=new list<contact>();
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadList[0].Id);
        lc.setDoNotCreateOpportunity(true);
       // lc.setAccountId(leadList[0].PartnerAccountId);
       // lc.setContactId(leadList[0].PartnerAccountId.AccountId);
 
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
                              
        Database.LeadConvertResult lcResults = Database.convertLead(lc);
        system.assert(lcResults.isSuccess());
        system.debug(lcResults.getContactId());
    }
    public void addSalutation(list<lead> leadList){
     List<Event> insertEventList=new List<Event>();   
     for(Lead lead:leadList)
      {
        lead.FirstName ='Dr ' + lead.FirstName;
        system.debug('Call ');
        // All Day Event Sample Code
   /*     Event eve= new Event();
        eve.IsAllDayEvent=true;
        eve.ActivityDate=lead.Start_Date__c+(15);     //How to add days in date (As well as used in flow) 
        eve.Subject='Test All day Event';
        eve.WhoId=lead.Id;
        eve.OwnerId=userinfo.getUserId();
        insert eve;   */
     //   insertEventList.add(eve);
       } 
        if(insertEventList.size()>0){
            Insert insertEventList;
        }
    }
}
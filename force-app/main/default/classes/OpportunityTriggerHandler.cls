public class OpportunityTriggerHandler {
    public void createEvent(map<Id,opportunity> newOppMap,Map<id,opportunity> oldOppMap)
    {
        list<Event> updateEventList=new list<Event>();
        set<Id> oppId=new set<Id>();
        for(opportunity op:newOppMap.values()) {
            if(op.StartDate__c != (oldOppMap.get(op.Id).StartDate__c)){
                oppId.add(op.Id);
                
            }
        }    
       List<Event> eventList=[select Id,subject,WhatId from Event where WhatId =:oppId];
       for(Event eve:eventList)
       {   
          eve.StartDateTime=oldOppMap.get(eve.WhatId).StartDate__c;
          eve.EndDateTime=oldOppMap.get(eve.WhatId).CloseDate;
          updateEventList.add(eve);    
       }
        if(updateEventList.size()>0){
            update updateEventList;
        } 
   }
    
    public void haveEvent(map<Id,Opportunity> oldOppMap){
        set<Id> oppId=new set<Id>();
        for(opportunity op:oldOppMap.values()){
            oppId.add(op.id);
        }
        list<Event> eventList=[select WhoId,EndDateTime from Event where WhatId In:oppId];
        if(eventList.size()>0)
        {
        //    oldOppMap.values().adderror('You can not delete this opportunity,because it have event record');
        }
    } 
}
trigger OpportunityTrigger on Opportunity (after insert,after update,before delete) {
    
    OpportunityTriggerHandler handler=new OpportunityTriggerHandler();
    if(trigger.isBefore)
    {
      if(trigger.isDelete){
          //  handler.haveEvent(trigger.oldMap);
        }
    }
    else if(trigger.isAfter)
    {
      if(trigger.isUpdate){
            handler.createEvent(trigger.newMap,trigger.oldMap);
        }
    }
}
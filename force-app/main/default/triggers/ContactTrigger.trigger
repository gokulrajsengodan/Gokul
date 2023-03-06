Trigger ContactTrigger on Contact (before insert,before update, after update) {
    
    ContactTriggerHandler handler=new ContactTriggerHandler();
    if(Trigger.isInsert)
    {
      if(Trigger.isBefore)
      {
      // handler.beforeInsert(Trigger.new); 
      }
      else if(Trigger.isAfter)
      {
           // write after insert function
      }    
    }
    else if(Trigger.isUpdate)
    {
      if(Trigger.isBefore)
      {
    //   handler.beforeUpdate(Trigger.new,Trigger.Old); 
       handler.beforeInsert(Trigger.new);   
          system.debug('Trigger Class');
      }
      else if(Trigger.isAfter)
      {
         //   handler.afterUpdate(Trigger.new,Trigger.old);
      }    
    }
}
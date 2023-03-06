trigger createcasetrigger on Account (after insert,before update) {
      

            AccountTriggerHandller Handller=new AccountTriggerHandller();
    if(trigger.isAfter && trigger.isInsert){
            Handller.createaccount(Trigger.new);
    }
    else if (trigger.isBefore && trigger.isUpdate){
        system.debug('Inside Account Trigger');
        Handller.updatePhone(trigger.new);
    }
    
}
trigger LeadTrigger on Lead (before insert,after insert) {
    
    LeadTriggerHandler handler=new LeadTriggerHandler();
    if(trigger.isInsert){
        if(trigger.isBefore){
             //    handler.addSalutation(trigger.new);
        }
        if(trigger.isAfter){
              //   handler.createContact(trigger.new);
        }
    }
}
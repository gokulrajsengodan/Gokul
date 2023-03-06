trigger AccconcaseTrigger on Account (before insert,after insert,before update,after update) {
    
     AccountcaseTriggerhandler handler=new AccountcaseTriggerhandler();
    if(trigger.isbefore){
        if(trigger.isinsert){
            handler.accountinsert(Trigger.new);
        }
        else if(trigger.isUpdate){
            // call the code;
        }
    }
    else if(trigger.isafter){
        if(trigger.isInsert){
          //  handler.createcontact(Trigger.new);
        }
        else if(trigger.isupdate){
            // call the code;
        }
    }
}
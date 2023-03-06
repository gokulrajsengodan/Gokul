public class ContactTriggerHandler {  
    
    ContactTriggerHelper helper=new ContactTriggerHelper();
    
    public void beforeInsert(List<Contact> newList){
        helper.restrictContactByName(newList);
        system.debug('newList size -->'+newList.size());
    }
    public void beforeUpdate(List<Contact> newList,List<Contact> oldList){   
        // helper.updateContact(newList,oldList);
        system.debug('Trigger apex Class 1');
    }
    public void afterUpdate(List<Contact> newList,List<Contact> oldList){   
         helper.chatterCreated(newList,oldList);
         helper.updateCaseCity(newList,oldList);
         helper.updateContactOppPhone(newList,oldList);
    }
}
trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {

    ContentDocumentLinkHandler handler = new ContentDocumentLinkHandler();
    if(trigger.isInsert){
        if(trigger.isAfter){
         //   handler.createTask(trigger.new);
        }
    }
}
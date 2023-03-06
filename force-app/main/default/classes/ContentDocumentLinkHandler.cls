public class ContentDocumentLinkHandler {
    
    public void createTask(list<ContentDocumentLink> newList){
        
        List<ContentDocumentLink> documentList=[select id,LinkedEntityId,ContentDocument.CreatedById from ContentDocumentLink where Id =: newList];
        
        for(ContentDocumentLink con : documentList){
            String sObjName = con.LinkedEntityId.getSObjectType().getDescribe().getName();
            String profileName = con.ContentDocument.CreatedBy.Profile.Name;
            if(sObjName == 'WorkItem__c' && profileName == ''){
            }
        }
    }
}
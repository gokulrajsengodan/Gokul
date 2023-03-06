public class GenerateResourceResumeActionController {

    @InvocableMethod
    public static void GenerateResourceResumeActionController(List<Resource__c> resourceList){
        
        PageReference ref = PAGE.ResourceResumePage;
        ref.getParameters().put('id', resourceList[0].Id);
        
        Blob b;
        if(!Test.isRunningTest()){
            b = ref.getContent();
        } else {
            b = blob.valueOf('Test Document');
        }
        
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = resourceList[0].Name +' Resume.pdf';
        conVer.Title = resourceList[0].Name +' Resume';
        conVer.VersionData = b;
        
        insert conVer;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = resourceList[0].Id;
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
    }
}
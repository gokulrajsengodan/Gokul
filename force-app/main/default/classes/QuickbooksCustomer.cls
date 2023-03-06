public class QuickbooksCustomer {
    public String FullyQualifiedName;  
    public PrimaryEmailAddr PrimaryEmailAddr;
    public String DisplayName;  
    public String Suffix;  
    public String Title;  
    public String MiddleName;  
    public String Notes;  
    public String FamilyName;  
    public PrimaryPhone PrimaryPhone;
    public String CompanyName;  
    public BillAddr BillAddr;
    public String GivenName;  
    public class PrimaryEmailAddr {
        public String Address;  
    }
    public class PrimaryPhone {
        public String FreeFormNumber;  
    }
    public class BillAddr {
        public String CountrySubDivisionCode;  
        public String City;  
        public String PostalCode;  
        public String Line1;  
        public String Country;  
    }





/*
public class SharePointUploader {
    
    // Define the maximum chunk size in bytes (default: 10 MB)
    private static final Integer MAX_CHUNK_SIZE = 6 * 1024 * 1024;
    
    // Upload a file to SharePoint by splitting it into chunks
    public static void uploadFile(String fileName, Blob fileBody) {
        
        // Initialize the SharePoint REST API endpoint URL
        String apiUrl = 'https://<your-sharepoint-site-url>/_api/web/getfolderbyserverrelativeurl(\'<your-sharepoint-folder-path>\')/files/add(url=\'' + fileName + '\',overwrite=true)';
        
        // Get the total size of the file in bytes
        Integer fileSize = fileBody.size();
        
        // Calculate the number of chunks needed to upload the file
        Integer numChunks = Math.ceil(fileSize / (double)MAX_CHUNK_SIZE).intValue();
        
        // Split the file into chunks and upload each chunk
        for (Integer i = 0; i < numChunks; i++) {
            
            // Calculate the range of bytes for this chunk
            Integer startByte = i * MAX_CHUNK_SIZE;
            Integer endByte = Math.min((i + 1) * MAX_CHUNK_SIZE, fileSize) - 1;
            
            // Create a new blob for this chunk
            Integer chunkSize = endByte - startByte + 1;
            Blob chunk = fileBody.mid(startByte, chunkSize);
            
            // Upload the chunk to SharePoint using its REST API
            String chunkUrl = apiUrl + '&startbyte=' + startByte + '&endbyte=' + endByte;
            HttpRequest request = new HttpRequest();
            request.setEndpoint(chunkUrl);
            request.setHeader('Content-Length', String.valueOf(chunkSize));
            request.setHeader('Content-Range', 'bytes ' + startByte + '-' + endByte + '/' + fileSize);
            request.setHeader('X-RequestDigest', '<your-request-digest-value>'); // replace with your request digest value
            request.setHeader('Content-Type', 'application/octet-stream');
            request.setMethod('POST');
            request.setBodyAsBlob(chunk);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            // Handle the response from SharePoint
            if (response.getStatusCode() != 201) {
                System.debug('Error uploading chunk ' + (i + 1) + ' of ' + numChunks + ': ' + response.getBody());
                break;
            } else {
                System.debug('Uploaded chunk ' + (i + 1) + ' of ' + numChunks);
            }
        }
    }    */

/*
 * 
    
    Integer MAX_CHUNK_SIZE = 6 * 1024 * 1024;
system.debug('MAX_CHUNK_SIZE '+MAX_CHUNK_SIZE);

List<File_Storage__mdt> fileStorageList = [SELECT Id,MasterLabel,DeveloperName,Name__c,Object_s__c,Type__c,Client_ID__c,Client_Secret__c,Resource_ID__c,Tenant_ID__c,SharePoint_Access_Token__c,Site_Name__c,Root_Folder__c
                                                       From File_Storage__mdt Where Type__c= 'SharePointOnline' limit 1];
File_Storage__mdt sharePoint = fileStorageList[0];

List<ContentVersion> cvList = [select id, title, ContentDocumentId, FileExtension, versionData, ContentSize from ContentVersion where Id ='068S0000002EooAIAS' order by createddate];
Blob fileBody = cvList[0].versionData;

Http http = new Http();
HTTPResponse httpResponse = new HTTPResponse();

Integer fileSize = cvList[0].ContentSize;
system.debug('fileSize '+fileSize);

Integer numChunks = Math.ceil(fileSize / (double)MAX_CHUNK_SIZE).intValue();
system.debug('numChunks '+numChunks);

Blob body = cvList[0].versionData;

for (Integer i = 0; i < numChunks; i++) {
    
    system.debug(' i '+i);
    // Calculate the range of bytes for this chunk
    Integer startByte = i * MAX_CHUNK_SIZE;
    Integer endByte = Math.min((i + 1) * MAX_CHUNK_SIZE, fileSize) - 1;
    system.debug(' startByte '+startByte);
    system.debug(' endByte '+endByte);
    
    // Create a new blob for this chunk
    Integer chunkSize = endByte - startByte + 1;
  String chunkData = EncodingUtil.base64Encode(body).substring(startByte, endByte + 1);
   Blob chunk = EncodingUtil.base64Decode(chunkData);
    system.debug(' chunkSize '+chunkSize);
    system.debug(' chunk '+chunk);
    string fileName;
    
    
    fileName = cvList[0].Title+'.'+cvList[0].FileExtension;
    fileName = fileName.replace(' ','%20');
        fileName=fileName.replaceAll('\'','\'\'');
        fileName=EncodingUtil.urlEncode(fileName, 'UTF-8');
    String targetFolderName='\''+fileName+'\'';
    String targetUri = 'https://jmcltd.sharepoint.com/sites/Org/Shared%20Documents/Salesforce/Testing/Opportunity/Test%20Opp%202';
    targetUri = targetUri.remove(sharePoint.Site_Name__c);
            targetUri=targetUri.replaceAll('\'','\'\'');
        targetUri=EncodingUtil.urlEncode(targetUri, 'UTF-8');
  //  targetUri=urlEncoding(targetUri);
    String baseUri = sharePoint.Site_Name__c+'_api/web/getfolderbyserverrelativeurl(';
    String endUri=')/Files/add(url='+targetFolderName+',overwrite=true)';
    String endPointUri=baseUri+'\''+targetUri+'\''+endUri;  
    String attachment=EncodingUtil.base64Encode(body);
    string contenType=cvList[0].FileExtension;
    String authToken = sharePoint.SharePoint_Access_Token__c;
    
    HttpRequest req = new HttpRequest(); 
    req.setHeader('Authorization','Bearer '+ authToken);
    req.setEndpoint(endPointUri);        
    req.setMethod('POST'); 
    req.setHeader('Connection', 'keep-alive');
    req.setHeader('Accept', 'application/json;odata=verbose');
    req.setHeader('Content-Type', contenType);
    //  req.setHeader('Content-Length', String.valueof(attachment.length()));
    req.setHeader('Content-Length', String.valueOf(chunkSize));
    req.setHeader('Content-Range', 'bytes ' + startByte + '-' + endByte + '/' + fileSize);
    Blob fileBlob=EncodingUtil.base64Decode(attachment);
    req.setBodyAsBlob(chunk);
    
    httpResponse = http.send(req);
    if(httpResponse.getStatusCode()==200 || httpResponse.getStatusCode()==201){
        System.debug('res' + httpResponse.getBody());
        System.debug('Uploaded chunk ' + (i + 1) + ' of ' + numChunks);
    }else{
        System.debug(System.LoggingLevel.DEBUG, 'Exeception Executed: '+httpResponse.getBody());
        System.debug('Error uploading chunk ' + (i + 1) + ' of ' + numChunks + ': ' + httpResponse.getBody());
        break;
        
    } 
}   */

}
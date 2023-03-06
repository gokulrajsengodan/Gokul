public class DebugLog {
    
    //  Schedma Object Debug 
    /* 

Schema.SObjectType s = Schema.getGlobalDescribe().get('Lead') ;
Schema.DescribeSObjectResult r = s.getDescribe() ;   
Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
system.debug('Result --> '+ Schema.getGlobalDescribe().get('account'));     
system.debug('Result --> '+r); 
system.debug('Result --> '+fields);

*/
    
    // Content Document Link Debug
    /*

List<ContentDocumentLink> documentList=[select id,LinkedEntityId,ContentDocument.CreatedBy.Profile.Name,ContentDocumentId from ContentDocumentLink where ContentDocumentId = '0695g000000u6xjAAA' ];
for(ContentDocumentLink con : documentList){
system.debug(con.Id);
String sObjName = con.LinkedEntityId.getSObjectType().getDescribe().getName();
String profileName = con.ContentDocument.CreatedBy.Profile.Name;
system.debug('Inside For Loop');
system.debug('Object Name--->'+sObjName);
system.debug('Profile Name--->'+profileName);
if(sObjName == 'Work_Item__c' && profileName != ''){
system.debug('Inside If Loop--->'+sObjName.Id);
} } 
*/
    
    // Find Out days between two dates 
   /* Date startDate = Date.newInstance(2008, 1, 1);
    Date dueDate = Date.newInstance(2008, 1, 2);
    Integer numberDaysDue = (startDate).daysBetween(dueDate);
    system.debug('Number of Days --->'+numberDaysDue);


    
    
    
    
    string phone = '0907080899';
    String fphone = phone.removeStart('0');
    String s = fphone.substring(0, 3) +' '+ fphone.substring(3, 6)+' '+ fphone.substring(6);
    string sPhone = '+421 '+s;
    system.debug('phone -->'+phone);
    system.debug('fphone -->'+sPhone);
    system.debug('Substring -->'+phone.substring(0,1));
    
    
    integer i=130; 
    Integer j;
    if(i<100){
        j =1;
    }
    else if(i>100){
        j =2;
    }
    system.debug(j);
    switch on j {
        when 1 {
            system.debug('Less than 100');
        }
        when 2 {
            system.debug('More than 100');
        }
    }
    
    
    
    
    Date checkIn = date.newinstance(2022,02,10);
    Date checkOuts = date.newinstance(2022,02,19);
    Integer totalDays = (checkIn).daysBetween(checkOuts);
    system.debug('total Days -->'+totalDays);
    
    
    
    CalendarView con = [SELECT OwnerId, DisplayField, Id, Name, SobjectType, StartField FROM CalendarView where Name ='Work Item' limit 1];
    CalendarView calendarView = new CalendarView(
        Name = con.Name, 
        SobjectType = con.SobjectType, 
        StartField = con.StartField,
        DisplayField = con.DisplayField, 
        OwnerId = '0055g00000499X4AAI');
    insert calendarView;
    
    
    
    String alphaSpace = 'aA Bb';
    System.assert(alphaSpace.isAlphaSpace());
    System.debug(alphaSpace.isAlphaSpace());
    String notAlphaSpace = 'ab 12';
    System.assert(!notAlphaSpace.isAlphaSpace());
    System.debug(notAlphaSpace.isAlphaSpace());
    notAlphaSpace = 'aA$Bb';
    System.assert(!notAlphaSpace.isAlphaSpace());
    System.debug(!notAlphaSpace.isAlphaSpace());
    
    Integer i=1;
    Boolean value = i > 0 ? true : false;
    system.debug('Value -->'+value);    
    
    
    String objType='Account';
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Schema.SObjectType leadSchema = schemaMap.get(objType);
    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
    
    for (String fieldName: fieldMap.keySet()) {
        
        Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
        system.debug('Display Type -->'+fielddataType);
    }
    
    
    string email = 'gokulrajs.691@gmail.com';
    system.debug(email.indexOf('@'));
    List<string> emialList= email.split('@');
    string e = 'gokulrajs.691@gmail';
    List<string> emailll= e.split('\\.');
    system.debug(email.split('@').size());
    system.debug(emailll);  
    
    */    
        public void apexCalloutGet(){
            // Example of Apex Callout
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            system.debug('Resounse -->'+ response);  
            system.debug('Response get body --->'+response.getbody());
            if(response.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                // Cast the values in the 'animals' key as a list
                system.debug('Results --->' +results);
                List<Object> animals = (List<Object>) results.get('animals');
                system.debug('animals --->' +animals);
                System.debug('Received the following animals:');
                for(Object animal: animals) {
                    System.debug(animal);
                }
            }
            
        }
    
    public void apexCalloutPost(){
        // Example of Apex Callout
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"name":"mighty moose"}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }
    
}
/*
   call in the workbench --> /services/apexrest/v1/Account
  post man ---> 
   Get code - Samplae - https://<INSTANCE>.salesforce.com/services/oauth2/authorize?response_type=code&client_id=<CONSUMER_KEY>&redirect_uri=https://login.salesforce.com
   <INSTANCE> - Org Instance - empathetic-shark-5jie81-dev-ed.my
   <CONSUMER_KEY> - connect app consumer key
   redirect_uri - should be what you have use in the connect app
  
 Get Access Token - https://<YOUR_INSTANCE>.salesforce.com/services/oauth2/token?code=<CODE>&grant_type=authorization_code&client_id=<CONSUMER_KEY>&client_secret=<CONSUMER_SECRET>&redirect_uri=https://login.salesforce.com/
   <code> - you will get previous step
   <INSTANCE> - Org Instance - empathetic-shark-5jie81-dev-ed.my
   <CONSUMER_KEY> - connect app consumer key
   redirect_uri - should be what you have use in the connect app

referal link : https://ei.docs.wso2.com/en/latest/micro-integrator/references/connectors/salesforce-connectors/sf-access-token-generation/
https://medium.com/@bpmmendis94/obtain-access-refresh-tokens-from-salesforce-rest-api-a324fe4ccd9b
 
 */

@RestResource(urlMapping='/v1/Account/*')
global with sharing class AccountManagerNew{
    
    @HttpDelete
    global static string deleteAccount(){
        RestRequest req = RestContext.request;
        string requestURI = req.requestURI;
        String accId = requestURI.substringAfterLast('/');
        List<Account> accList = [SELECT Id FROM Account WHERE Id = :accId limit 1];
        if(accList.size()>0){
            try{
                delete accList;
                return '{"message" : "Account record deleted"}';
            }catch(system.Exception ex){
                string errorMessage = ex.getMessage();
                return '{"message" : "'+errorMessage+'"}';
            }
        }else{
            return '{"message" : "Account record not found"}';
        }
    }
    
    @HttpPatch
    global static ResponseWrapper updateAccount(string industry, string description){
                RestRequest req = RestContext.request;
        string requestURI = req.requestURI;
        String accId = requestURI.substringAfterLast('/');
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Id = :accId limit 1];
        Account acc;
        ResponseWrapper res = new ResponseWrapper();
        if(accList.size()>0){
            acc = new Account(Id=accId,Industry = industry, Description = description);
            update acc;
            res.accountRec = acc;
            res.message = 'Account Record Updated';
        }else{
            res.message = 'Account Record not Found';
        } 
        return res;
    }
    
    @HttpPost
    global static Account postAccount(string accName, string industry, string description){
        Account acc = new Account(Name = accName, Industry = industry, Description = description);
        insert acc;
        return acc;
    }
    
    @HttpGet
    global static AccountWrapper accountInformation(){
        RestRequest req = RestContext.request;
        string requestURI = req.requestURI;
        String accId = requestURI.substringAfterLast('/');
        system.debug('requestURI '+requestURI);
        system.debug('accId '+accId);
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :accId limit 1];
        List<Contact> contactList = [select Id,Name from Contact Where AccountId =:accId];
        List<Case> caseList = [select Id,Subject,CaseNumber from Case Where AccountId =: accId];
        AccountWrapper wrapper = new AccountWrapper();
        if(acc != null){
            wrapper.accountRecord = acc;
            wrapper.contactList = contactList;
            wrapper.caseList = caseList;
        }
        return wrapper;
        
    }
    
    global class AccountWrapper{
        global Account accountRecord;
        global List<Contact> contactList;
        global List<Case> caseList;
    }
    
    global class ResponseWrapper{
        global Account accountRec;
        global string message;        
    }
}
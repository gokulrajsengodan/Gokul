@isTest
public class AccountManagerNewTest {
    
    @testSetup 
    public static void setup(){
        Account acc = new Account(Name='Test Account');
        insert acc;
        Contact con = new Contact(LastName = 'Test Contact',AccountId = acc.Id);
        insert con;       
    }
    
    
    public static testMethod void getAccount(){
        string url = '/service/apexrest/v1/Account/'  + [select Id from Account Where name = 'Test Account'].Id;
        RestRequest request = new RestRequest();
        request.requestURI = url;
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        Test.startTest();
        AccountManagerNew.AccountWrapper wrapper = AccountManagerNew.accountInformation();
        system.assertNotEquals(null, wrapper);
        Test.stopTest();        
    }
    
    public static testMethod void postAccount(){
        string url = '/service/apexrest/v1/Account/';
        RestRequest request = new RestRequest();
        request.requestURI = url;
        request.httpMethod = 'POST';
        
        Test.startTest();
        Account acc = AccountManagerNew.postAccount('Test Accounts','Education','Test');
        system.assertNotEquals(null, acc);
        Test.stopTest();        
    }
    
    public static testMethod void updateAccount(){
        string url = '/service/apexrest/v1/Account/'  + [select Id from Account Where name = 'Test Account'].Id;
        RestRequest request = new RestRequest();
        request.requestURI = url;
        request.httpMethod = 'PATCH';
        
        RestContext.request = request;
        Test.startTest();
        AccountManagerNew.ResponseWrapper wrapper = AccountManagerNew.updateAccount('Education','Test 1');
        system.assertNotEquals(null, wrapper);
        Test.stopTest();        
    }
    
    public static testMethod void deleteAccount(){
        string url = '/service/apexrest/v1/Account/'  + [select Id from Account Where name = 'Test Account'].Id;
        RestRequest request = new RestRequest();
        request.requestURI = url;
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        Test.startTest();
        string wrapper = AccountManagerNew.deleteAccount();
        system.assertNotEquals(null, wrapper);
        Test.stopTest();        
    }
    
}
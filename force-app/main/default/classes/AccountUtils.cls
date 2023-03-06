public class AccountUtils {
    
    public static List<Account> accountsByState (string state){
        
        List<Account> accountList = [select id,name,BillingState from account where BillingState =: state];
        Map<Id,string> accountMap = new Map<Id,string>();
        for(Account acc : accountList){
         accountMap.put(acc.id,acc.name);  
        }
        system.debug('Account Map --->'+ accountMap);
        return accountList;
        
    }
}
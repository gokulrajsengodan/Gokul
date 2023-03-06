public class AccountHandler {
    
     public static void insertAccount(Integer value){
        Integer n = 1;
        List<Account> addAccounts = new List<Account>();
        while(n <= value){    
       System.debug('Counter Value before Incrementing ' + n);
            Account store = new Account();
            store.Name = 'Acme Inc  ' + n;
            store.AccountNumber = 'A000' + n;
            addAccounts.add(store);
            System.debug(addAccounts);
            n = n + 1;
            System.debug('Counter Value after incrementing ' + n);
        }
        System.debug('Size of Account List: ' + addAccounts.size() );
        System.debug('Elements in Account List: ' + addAccounts);
        insert addAccounts;
    }
}
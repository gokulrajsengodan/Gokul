public class AccountTriggerHandller {
  public void createaccount(list<account>accountlist){
        list<case>de=new list<case>();
        for(account ac:accountlist){
            for(integer i=1;i<=3;i++)
            {
            case ca=new case();
            ca.AccountId=ac.Id;
            ca.Status='working';
            ca.Origin= 'phone';
            de.add(ca);
            }
            insert de;
        }     
    }
    public void updatePhone(list<Account> accList){
        list<Account>updateList=new list<Account>();
        for(Account acc:accList){
            if(acc.Phone == Null){
                  acc.Phone='12345';
              //  acc.Data_Quality_Score__c = 2;
                updateList.add(acc);
                }
        }
        if(updateList.size()>0){
            update updateList;
        }
    }  
}
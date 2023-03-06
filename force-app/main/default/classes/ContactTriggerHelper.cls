public class ContactTriggerHelper {
    
    public void names(string Names){  
        String query = 'SELECT Id,Name from Contact where Name ='+Names;
        List<sObject> projectList = Database.query(query);
        system.debug('projectList -->'+projectList);
    } 
    
    
    public void restrictContactByName(List<Contact> newList){
        //check contacts prior to insert or update for invalid data
        set<Id> setAccountIds = new set<Id>();
        for (Contact c : newList) {
            system.debug('Account Name -->'+c.AccountId);
            system.debug('Account Name 1-->'+c.Account.Id);
            system.debug('Account Name 2-->'+c.Account.Name);
            if(c.LastName == 'INVALIDNAME') {	//invalidname is invalid
                c.LastName.addError('The Last Name "'+c.LastName+'" is not allowed for DML');
                c.Phone.addError('The Last Name "'+c.LastName+'" is not allowed for DML');
            }
            if(c.AccountId != null && c.Account.Name == 'Hyndai Private Limited'){
                c.addError('We can not save this contact under the Hyndai Private Limited Account');
            }
                            setAccountIds.add(c.AccountId);
        }
        
        List<Account> accList = [SELECT Id,Name  FROM Account where Id IN: setAccountIds];
        for(Contact con : newList){
            if(accList[0].Name == 'Hyndai Private Limited'){
                             con.addError('We can not save this contact under the Hyndai Private Limited Account');
   
            }
        }

        
        List<Account> accContactMap = new List<Account>();
        if(setAccountIds.size()>0){
            accContactMap = [SELECT Id, (select Id,Name,Birthdate,BirthTime__c from Contacts) FROM Account where Id IN: setAccountIds];
        }
                    system.debug('setAccountIds -->'+setAccountIds.size());
       Map<Id,Map<Date,List<Time>>> dateTimeMap = new Map<Id,Map<Date,List<Time>>>();
        if(accContactMap.size()>0){
            system.debug('accContactMap -->'+accContactMap);
        for(Account acc : accContactMap){
            Map<Date,List<Time>> birthMap = new Map<Date,List<Time>>();
            for(contact con : acc.Contacts){
                if(birthMap.containsKey(con.Birthdate)){
                    List<Time> oldTimeList = birthMap.get(con.Birthdate);
                    oldTimeList.add(con.BirthTime__c);
                    birthMap.put(con.Birthdate,oldTimeList);
                } else{
                    List<Time> newTimeList = new List<Time>{con.BirthTime__c};
                    birthMap.put(con.Birthdate,newTimeList);
                }
            } 
            dateTimeMap.put(acc.Id,birthMap);
        }                 
        }
        system.debug('dateTimeMap'+dateTimeMap);
        if(dateTimeMap.size()>0){
        for (Contact con : newList) {
            if( con.Birthdate != null && dateTimeMap.get(con.AccountId).containskey(con.Birthdate)) {	
                if( con.BirthTime__c != null && dateTimeMap.get(con.AccountId).get(con.Birthdate).contains(con.BirthTime__c)){
                    //  con.addError('Aleady one fo record have same birth date and birth time under this account');
                }
            }
        }
        }
        
    }
    
    public void updateContact(List<Contact> newList,List<Contact> oldList)
    { 
        list<Contact> updateContactList=new list<Contact>();
        for(Contact ac:newList) 
        {
            if(ac.LeadSource == 'Web' && ac.Description.contains('ss'))
            {
                ac.Phone = '1233456678';
                updateContactList.add(ac);   
            }  
        }
        if(updateContactList.size()>0){
            update updateContactList;
        }
    }
    
    public  void chatterCreated(List<Contact>  newList,List<Contact> oldLsit)
    {
        list<FeedItem> feedList=new list<FeedItem>();
        for(Contact ac:newList)
        {
            FeedItem post = new FeedItem();
            post.ParentId = ac.Id;
            post.Body = '#review  @@hm.cz (Private)';
            feedList.add(post);
        }
        if(feedList.size()>0){
            insert feedList;
        }
    }
    
    public void updateCaseCity(List<Contact> newList,List<Contact> oldList){
        set<id> contactIds=new set<id>();
        for(contact c:newList)
        {
            if(c.city__c != oldList[0].city__c ){  contactIds.add(c.id);   } 
        }
        list<Case> caseList=[select id,city__c,contactId from Case where contactid in:contactIds];
        list<Case> updaetCaseList=new list<Case>();
        for(Case co:caseList)
        {
            co.city__c=newList[0].city__c;
            updaetCaseList.add(co); 
        }
        if(updaetCaseList.size()>0){
            update updaetCaseList;   
        }
    }
    
    public void updateContactOppPhone(List<Contact> newList,List<Contact> oldList){
        list<Account> updateAccountList=new list<Account>();
        list<Opportunity> updateOppList=new list<opportunity>();
        set<Id> accountId=new set<Id>();
        Map<Id,Contact> contactMap=new Map<Id,Contact>(); 
        for(contact con:newList){
            if(con.phone != null && con.AccountId !=null){
                accountId.add(con.AccountId);
                contactMap.put(con.AccountId,con);
            }
        }
        list<Account> accList=[select Id,phone from Account where Id In:accountId];
        List<Opportunity> oppList=[select Id,AccountId from Opportunity where AccountId In:accountId];
        Map<Id,List<Opportunity>> oppAccountMap=new Map<Id,List<Opportunity>>(); 
        for(Opportunity opp:oppList){
            if(oppAccountMap.ContainsKey(opp.AccountId)){
                List<Opportunity> opList=oppAccountMap.get(opp.AccountId);
                opList.add(opp);
                oppAccountMap.put(opp.AccountId,opList);
            }
            else{
                List<Opportunity> opNewList=new List<Opportunity>();
                opNewList.add(opp);
                oppAccountMap.put(opp.AccountId,opNewList);
            }
        } 
        for(account ac:acclist){
            if(ac.Phone == null){
                ac.Phone=contactMap.get(ac.Id).Phone;
                updateAccountList.add(ac);
                for(Opportunity opp:oppAccountMap.get(ac.Id)){
                    opp.Account_Phone__c=ac.Phone;
                    updateOppList.add(opp);
                }
            }    
            else{    
                for(Opportunity opp:oppAccountMap.get(ac.Id)){
                    opp.Account_Phone__c=ac.Phone;
                    updateOppList.add(opp);
                }
            }
        }
        if(updateAccountList.size()>0){
            update updateAccountList;
        }
        if(updateOppList.size()>0){
            update updateOppList;
        } 
    }
}
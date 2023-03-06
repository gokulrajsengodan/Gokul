trigger Divideamount on Account (after insert,after update) {
    list<account>acclist=[select id,name,Balance__c,(select id,name,Individual_Balance__c from contacts)from account where Balance__c>0];
    list<contact>contactlist=new list<contact>();
    for(account ac:acclist)
  {
      if(ac.contacts.size()>0)
      {
          Decimal storeAmount=ac.Balance__c/ac.contacts.size();
      
      for(contact cc:ac.contacts)
      {
          cc.Individual_Balance__c=storeAmount;
          contactlist.add(cc);
      }
      update contactlist;
  }
  }    
}
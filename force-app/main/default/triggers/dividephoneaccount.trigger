trigger dividephoneaccount on Account (After update) {
    list<contact>az=new list<contact>();
    set<id>accid=new set<id>();
  for(account ac:trigger.new)
  {
      if(ac.phone!=trigger.oldmap.get(ac.id).phone) {
          accid.add(ac.id);
      }
  }
   list<account>ash=[select id,name,(select id,Phone,MobilePhone from contacts)from account where id =:accid]; 
   for(account ab:ash)
   {
       for(contact co:ab.contacts){
           co.Phone=trigger.oldmap.get(ab.id).Phone;
           co.MobilePhone=trigger.newmap.get(ab.id).phone;
           az.add(co);
       }
       if(!az.isEmpty())
       {
           update az;
       }
   }





}
trigger deletecontact on Account (before insert) {Set<id> Accountids = new Set<id>();
        for(account acc:trigger.old)
        {
        Accountids.add(acc.id);
        }
    
List<Account> account = [select id,name,(select id, name from contacts) from account where id in: Accountids];
Map<id,Account> mapacc = new Map<id,Account>();
for(account a:account){
}
//for showing error use context variable bcoz error shows on context variable
 for(account acc:trigger.old)
        {
        if(mapacc.get(acc.id).contacts.size()>=2)
                {
                acc.adderror('account cannot be deleted');
                }
        }
}
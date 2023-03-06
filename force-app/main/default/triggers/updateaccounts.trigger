trigger updateaccounts on Account (after update) {
    Set<id> AccountIds = new Set<id>();
    for(Account a: trigger.new)
    {
        if(a.city__c != trigger.oldmap.get(a.id).city__c){
        AccountIds.add(a.id);
    }
    }
    List<opportunity> opport=[select id, City__c,Accountid from Opportunity where accountid in: Accountids];
    
        for(opportunity opp:opport)
        {
                     opp.City__c = trigger.newmap.get(opp.accountid).city__c;
        }
        update opport;
}
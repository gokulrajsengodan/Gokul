trigger WorkItemTrigger on Work_Item__c (before insert) {
    If(trigger.isBefore){
        system.debug('Trigger.new -->'+trigger.new);
        for(Work_Item__c work : trigger.new ){
            work.Work__c = 'a0p5g000000yqtaAAA';
        }
    }
}
public with sharing class lwcClass {
    public lwcClass(){
        
    }
    @AuraEnabled(Cacheable=true)
    public static list<LWC_Obj__c> getRecordList(){
        return [select Id,X1st_CheckBox__c,X2nd_CheckBox__c,Description__c,	Name,Heading__c from LWC_Obj__c];
    }
    @AuraEnabled
    public static list<LWC_Obj__c> getUpdateRecords(string ids,Boolean checkBox1,Boolean checkBox2){
        list<LWC_Obj__c>customList=[select Id,X1st_CheckBox__c,X2nd_CheckBox__c,Description__c,	Name from LWC_Obj__c where Name =: ids];
       list<LWC_Obj__c>con=new list<LWC_Obj__c>();
        system.debug('Inside Class Method');
        for(LWC_Obj__c lcm : customList)
        {
            if(checkBox1 != null){
            lcm.X1st_CheckBox__c=checkBox1;
            system.debug('For Loop Method');
            }
            else if(checkBox2 != null){
                lcm.X2nd_CheckBox__c=checkBox2;
            }
            con.add(lcm);
        }
        update con;
        return con;
    }
}
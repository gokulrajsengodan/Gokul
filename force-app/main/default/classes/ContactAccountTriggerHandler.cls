public class ContactAccountTriggerHandler {
    set<id>conid=new set<id>(); 
    
     /*   decimal total;
        list<contact>con=[select id,Salary__c,LeadSource from contact where AccountId in: conid];
    public void contactinsert(list<contact>cons){
        for(contact c:cons){
            conid.add(c.AccountId);
        }
        for(contact co:con){
            if(co.LeadSource == 'web'){
                total.add(co.Salary__c);
            }
        }
        if(conid.Total_Salary__c <= total){
           conid.Rating ='Hot'; 
        }
        else{
             conid.Rating ='Warm';
        }
    } */
}
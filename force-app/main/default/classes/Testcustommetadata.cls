public class Testcustommetadata {

    public void custommeatdata(){
        list<country__mdt>cmdlist=[select 	MasterLabel,Regions__c from country__mdt];
        for(country__mdt co:cmdlist){
        if(co.MasterLabel == 'USA'){
                system.debug('Region=====>'+co.Regions__c);
        }
    }
    }
}
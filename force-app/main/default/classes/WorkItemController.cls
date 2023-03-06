public class WorkItemController {
    
    public Work_Item__c work {get;set;}
     public string editId {get;set;}
    public List<Work_Item__c> workItemList {get;set;}
    
    public WorkItemController(){
        work = new Work_Item__c();
    }
    
  public WorkItemController(ApexPages.StandardController s){
              workItemList = [select Id,Name,Work_Time__c,Work_Type__c,Start_Date_Time__c,Finish_Date_Time__c from Work_Item__c order by createddate desc];
    }  
    
    public list<SelectOption> gettime(){
        List<SelectOption> listTime = new List<SelectOption>();
        List<Schema.PicklistEntry> picklistValues = Work_Item__c.Work_Time__c.getDescribe().getPickListValues();
        for(Schema.PicklistEntry times : picklistValues){
            listTime.add(new SelectOption(times.getValue(),times.getLabel()));
        }
        return listTime;
    }
    
    public List<Work_Item__c> getworkItemLists(){
         system.debug('Inside apex class');
        return [select Id,Name,Work_Time__c,Work_Type__c,Start_Date_Time__c,Finish_Date_Time__c from Work_Item__c order by createddate desc];
   
    }
    
    public void editaction(){
        system.debug('Edit Id -->'+ editId);
      //  work = [select Id,Name,Work_Time__c,Work_Type__c,Start_Date_Time__c,Finish_Date_Time__c from Work_Item__c where Id =:editId];
    }
    
    public void save(){
        system.debug('Inside save action -->'+work);
        Work__c obj = [select id from Work__c where Id = 'a0p5g000000yqtaAAA'];
        work.Work__c = obj.Id;
        try{
            If(work != null){
                insert work;
            }
            If(work.Id != null){
                Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.CONFIRM, 'Work Item Record Saved Successfully'));
                work = new Work_Item__c();
            }
        }
        catch(exception e){
            system.debug('Error -->'+e.getMessage());
        }finally{
            
        }
    }
}
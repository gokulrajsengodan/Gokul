public class WorkExtension {

    public List<Work__c> workList {get;set;}
    public string searchText {get;set;}
    
    public WorkExtension(ApexPages.StandardController s){
              workList = [select Id,Name from Work__c order by createddate desc];
    }  
    
   public WorkExtension(WorkItemController ww){
              workList = [select Id,Name from Work__c order by createddate desc];
    }  
    
   public List<Work__c> search(){
             searchText = searchText+'%';
       if(searchText != null){
           workList = [select Id,Name from Work__c order by createddate desc];
       }
       else{
                          workList = [select Id,Name from Work__c where Name like:searchText order by createddate desc];
       }
       return workList;
    }  
}
public with sharing class PieChartWork {

   @AuraEnabled(Cacheable=true)
   public static List<String> getRecordList(){
        List<Opportunity> workList = [select Name,Account.Name from 	Opportunity];
        List<String> nameList = new list<String>();
       for(	Opportunity work : workList){
           if(!nameList.contains(work.Account.Name)){
           nameList.add(work.Account.Name);
           }
       }
       return nameList;
   }
}
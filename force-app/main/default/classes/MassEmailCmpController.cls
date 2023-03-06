public with sharing class MassEmailCmpController {
    
    @AuraEnabled(cacheable=true)
    public static List<ObjectApiNameandLabel> getObjectList(){ 

    List<ObjectApiNameandLabel> objectNameMap = new List<ObjectApiNameandLabel>();
    List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
    List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
    List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
    List<string> objApiNameList = new List<string>();
    Map<string,Schema.DescribeSObjectResult> objApiNameMap = new Map<string,Schema.DescribeSObjectResult>();

       
    for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }
    Map<string,string> iconMap = new Map<string,string>();
    Map<Schema.DescribeIconResult,string> iconDescMap = new Map<Schema.DescribeIconResult,string>();
    string icon;
     for(Schema.DescribeTabResult tr : tabDesc) {
             if( tr.isCustom() == true ) {
                 iconDesc.addAll(tr.getIcons());
                 iconDescMap.put(tr.getIcons()[0],tr.getSobjectName());
               //  iconDescMap.put(tr.getIcons()[2],tr.getSobjectName());
             } else {
                 if(tr.getSobjectName() == 'Order'){
                     icon = 'standard:' + tr.getLabel().toLowerCase();
                 }
                 else{
                     icon = 'standard:' + tr.getSobjectName().toLowerCase();
                 }
                 iconMap.put(tr.getSobjectName(),icon);
             }
     }
     for (Schema.DescribeIconResult ir : iconDesc) {
         if (ir.getContentType() == 'image/svg+xml'){
             icon = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
             iconMap.put(iconDescMap.get(ir),icon);
         }
     }
    
    
    for(Schema.SObjectType o : Schema.getGlobalDescribe().values()){
            Schema.DescribeSObjectResult objResult = o.getDescribe();
            String name = objResult.getName();
            If(!name.containsignorecase('history') && !name.containsignorecase('tag')&&
            !name.containsignorecase('share') && !name.containsignorecase('feed') && 
            !objResult.getLabel().containsignorecase('Change Event') && objResult.getRecordTypeInfos().size()>0){
                objApiNameList.add(objResult.getName());
                objApiNameMap.put(objResult.getName(),objResult);
            }
        }
        objApiNameList.sort();
        if(objApiNameList.size()>0){
        for(string name : objApiNameList){
            ObjectApiNameandLabel obj = new ObjectApiNameandLabel();
            obj.apiName = objApiNameMap.get(name).getName();
            obj.label = objApiNameMap.get(name).getLabel();
            obj.iconName = iconMap.get(name);
            objectNameMap.add(obj);
        }
    }

        return objectNameMap;
    }

    @AuraEnabled
    public static DataTableResponse getObjectTabelData(String objectApiName)
    {
        system.debug('objectApiName -->'+objectApiName);
        List<string> emailFieldList = new List<string>();
        List<DataTableColumns> dataColumnsList  = new List<DataTableColumns>();

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectApiName);
        Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
        for (Schema.SObjectField field : fieldMap.values()) {
        if(string.valueof(field.getDescribe().getType()) == 'EMAIL'|| field.getDescribe().getName().equals('Name')){
                System.debug(field.getDescribe().getName());
                System.debug(field.getDescribe().getLabel());
                  System.debug(field.getDescribe().getType());
                     emailFieldList.add(field.getDescribe().getName());
                     DataTableColumns datacolumns = new DataTableColumns();
                     datacolumns.label = field.getDescribe().getLabel();
                     datacolumns.fieldName = field.getDescribe().getName();
                     datacolumns.type = string.valueof(field.getDescribe().getType());
                     datacolumns.editable = true;
                     datacolumns.sortable = true;
                     dataColumnsList.add(datacolumns);
        }
     }
     system.debug('emailFieldList -->'+emailFieldList);
     system.debug('dataColumnsList -->'+dataColumnsList);
     string apiNames='';
     for(string field : emailFieldList){
        if(field !=''){
            if(apiNames == ''){
                apiNames =','+ field;
            }else{
                apiNames = apiNames+','+field;
            }
            system.debug('field -->'+field);
            system.debug('apiNames -->'+apiNames);
        }
     }
     system.debug('apiNames 1-->'+apiNames);
     String query = 'SELECT Id ' + apiNames + ' FROM '+objectApiName;
     system.debug('query -->'+query);
     List<sObject> sobjList = Database.query(query);

        DataTableResponse finalWrapper   = new DataTableResponse();
        finalWrapper.dataTableColumnsList = dataColumnsList;
        finalWrapper.objectDataList = sobjList;
        system.debug('finalWrapper -->'+finalWrapper);
        return finalWrapper;
    }

    public class ObjectApiNameandLabel{
        
        @AuraEnabled
        public string apiName;
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string iconName;

    }

   public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public boolean editable {get;set;}
        @AuraEnabled
        public boolean sortable {get;set;}
    }
    
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> dataTableColumnsList {get;set;}
        @AuraEnabled
        public List<sObject> objectDataList {get;set;}     
    }


}
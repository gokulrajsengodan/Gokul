public without sharing class ResourceResumePageController {
    public String recordId{get;set;}
    public Resource__c resource{get;set;}
    public List<Education__c> educationList{get;set;}
    public List<Work_Experience__c> workExpList{get;set;}
    public List<Resource_Certification__c> certificateList{get;set;}
    public List<Accomplishment__c> workAccomplishList{get;set;}
    public Map<String,List<Accomplishment__c>> workAccomplishMap{get;set;}
    public List<String> developmentSkills{get;set;}
    public List<String> implementationSkills{get;set;}
    public List<String> languages{get;set;}
    public String photoSrc{get;set;}
    public ResourceResumePageController(){
        workAccomplishMap = new Map<String,List<Accomplishment__c>>();
        recordId = apexpages.currentpage().getparameters().get('id');
        resource = [SELECT Id,Name,Mobile_Number__c,Email__c,Photo__c,Role__c,Current_City__c,Current_State__c,Current_Country__c,About__c,Salesforce_Development_Skills__c,Salesforce_Implementation_Skills__c,Languages_Known__c FROM Resource__c WHERE Id=:recordId];
        educationList = [SELECT Id,Name,Degree__c,Field_of_Study__c,From_Date__c,To_Date__c,Institution__c FROM Education__c WHERE Resource__c=:recordId ORDER BY To_Date__c DESC];
        workExpList = [SELECT Id,Name,Job_Title__c,From_Date__c,To_Date__c,Company_Name__r.Name,Currently_Working_Here__c FROM Work_Experience__c WHERE Resource__c=:recordId ORDER BY To_Date__c DESC];
        certificateList = [SELECT Id,Name,Certification_Name__r.Certification_Name__c FROM Resource_Certification__c WHERE Resource__c=:recordId ORDER BY Order__c ASC];
        workAccomplishList = [SELECT Id,Name,Accomplishment_Heading__c,Work_Experience__c FROM Accomplishment__c WHERE Work_Experience__c IN:workExpList ORDER BY Order__c ASC];
        for(Accomplishment__c acc:workAccomplishList){
            List<Accomplishment__c> accomplishList = new List<Accomplishment__c>();
            if(workAccomplishMap.containsKey(acc.Work_Experience__c)){
                accomplishList = workAccomplishMap.get(acc.Work_Experience__c);
            }
            accomplishList.add(acc);
            workAccomplishMap.put(acc.Work_Experience__c,accomplishList);
        }
        for(Work_Experience__c exp:workExpList){
            List<Accomplishment__c> accomplishList = new List<Accomplishment__c>();
            if(!workAccomplishMap.containsKey(exp.Id)){
                workAccomplishMap.put(exp.Id,new List<Accomplishment__c>());
            }
        }
        
        photoSrc = String.isNotBlank(resource.Photo__c)?getImageSrc(resource.Photo__c):'';
        developmentSkills = resource.Salesforce_Development_Skills__c.split(';');
        implementationSkills = resource.Salesforce_Implementation_Skills__c.split(';');
        languages = resource.Languages_Known__c.split(';');
    }
    public String getImageSrc(String text){
        String imageURL='';
        Matcher imgMatcher = Pattern.compile( '<img(.+?)>' ).matcher(text);
        if (imgMatcher.find()) {
            String imageTag = imgMatcher.group();            
            imageURL= imageTag.substringBetween('src="', '"' );
        }
        return imageURL.unescapeHtml4();
    }
}
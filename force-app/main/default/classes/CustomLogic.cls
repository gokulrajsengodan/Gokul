public class CustomLogic {
    
    public static void custom(){
        
        
        string logic = '((1 AND 2) OR (3 AND 4)) AND 5';
        string a = logic.deleteWhitespace().toUpperCase();
        Integer openBracketCount = 0;
        Integer closeBracketCount = 0;
        List<string> logicList = a.splitByCharacterType();
        system.debug(logicList);
        system.debug(logicList.size());
        map<string,List<string>> vehicleMap= new map<string,List<string>>();
        vehicleMap.put('1',new List<string>{'kicks','Duster','Captur'});
        vehicleMap.put('2',new List<string>{'kicks','RediGo','Maginte'});
        vehicleMap.put('3',new List<string>{'RediGo','Duster','kicks'});
        vehicleMap.put('4',new List<string>{'kicks','Triber','Maginte'});
        vehicleMap.put('5',new List<string>{'kicks','Duster','RediGo'});
        List<string> parentList = new List<string>();
        List<string> child1List = new List<string>();
        List<string> child2List = new List<string>();
        string parentCondition = '';
        string childCondition = '';
        Integer result = 0;
        for(string ss : logicList){
            system.debug(ss.deleteWhitespace());
            string log = ss.deleteWhitespace();
            if(log.startsWith('(')){
                openBracketCount = openBracketCount + log.length();
            }
            else if(log.isNumeric()){
                child2List = customCondition(log,childCondition,parentCondition,vehicleMap,child1List,child2List,parentList);
                if((result + 1) == logicList.size()){
                    parentList.addAll(child2List);
                }
            }
            else if(log.startsWith(')')){
                closeBracketCount = closeBracketCount + log.length();
                if(openBracketCount == closeBracketCount){
                    if(parentCondition == 'OR'){
                        child1List.addALL(child2List);
                    }
                    else{
                        List<string> newList = new List<string>();
                        for(string car : child2List){
                            if(child1List.contains(car)){
                                newList.add(car);
                            }
                        }  
                        child1List = newList;                                
                    }
                    parentList.addAll(child1List);
                    child1List.clear();
                    child2List.clear();
                }
                else{
                    if( parentCondition == ''){
                        child1List.addAll(child2List);
                        child2List.clear();
                    }else{
                        if(parentCondition == 'OR'){
                            child1List.addALL(child2List);
                        }
                        else{
                            List<string> newList = new List<string>();
                            for(string car : child2List){
                                if(child1List.contains(car)){
                                    newList.add(car);
                                }
                            }  
                            child1List = newList;                                
                        }
                    }
                }
            }
            else{
                //   Integer result = logicList.indexOf(ss);
                if(result > 0 && logicList[result - 1].isNumeric()){
                    childCondition = log;
                }
                else{
                    parentCondition = log;
                    childCondition = '';
                }
                system.debug(ss);
                system.debug(result);
                system.debug(logicList.indexOf(ss));
                system.debug(logicList[result - 1]);
            }
            system.debug('log -->'+log);
            system.debug('parentCondition -->'+parentCondition);
            system.debug('childCondition -->'+childCondition);
            system.debug('parentList -->'+parentList);
            system.debug('child1List -->'+child1List);
            system.debug('child2List -->'+child2List);
            result = result + 1;
        }
        system.debug('openBracketCount -->'+openBracketCount);
        system.debug('closeBracketCount -->'+closeBracketCount);
        system.debug('Final List -->'+parentList);
    }
    
    public static List<string> customCondition(string log,string childCondition,string parentCondition,map<string,List<string>> vehicleMap,List<string> child1List,List<string> child2List,List<string> parentList){
        
        if(childCondition == '' && (parentList.size() == 0 || (parentList.size() > 0 && child1List.size() > 0 ))){
            child2List.addALL(vehicleMap.get(log));
        }
        else if(childCondition != ''){
            if(childCondition == 'OR'){
                child2List.addALL(vehicleMap.get(log));
            }
            else{
                List<string> newList = new List<string>();
                for(string car : vehicleMap.get(log)){
                    if(child2List.contains(car)){
                        newList.add(car);
                    }
                }  
                child2List = newList;                                
            }
        }
        else{
            if(parentCondition == 'OR'){
                child2List.addALL(vehicleMap.get(log));
            }
            else{
                List<string> newList = new List<string>();
                for(string car : vehicleMap.get(log)){
                    if(parentList.contains(car)){
                        newList.add(car);
                    }
                }  
                child2List = newList;                                
            }
        }
        return child2List;
    }


    /*
 public static void sendCompanyCreationForm(Id contactId){
        system.debug('Inside the sendCompanyCreationForm method -->'+contactId);
        Contact con = [select Id, Email, LastName from contact where Id =: contactId];
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        String templateName = system.label.Company_Creation_Form_Template;
        EmailTemplate emailTemplate = [select Id, Name from EmailTemplate where Name = templateName];
        String owdAddressName = system.label.Smart_Company_OWD;
        OrgWideEmailAddress OrgEmailFromAddress = [select Id, Address from OrgWideEmailAddress where Address = owdAddressName];

        if(con != null && con.Email!=null){
                mail.setTargetObjectId(con.Id);
                mail.setTemplateId(emailTemplate.Id);	
                mail.setSaveAsActivity(true);
                mail.setUseSignature(false); 
                if(OrgEmailFromAddress != null){
                    mail.setOrgWideEmailAddressId(OrgEmailFromAddress.Id);
                }
                mailList.add(mail);
            }
        if(mailList.size() > 0)
        {
            system.debug('Mail will be sent form here');
            Messaging.sendEmail(mailList);
        }
}

public static void sendEmail(List<sObject> objectList,Id emailTemplateId,Id orgWideAddressId){
       for(sObject obj : objectList)
        {
            if(obj.Email != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(emailTemplateId);
                mail.setTargetObjectId(obj.Id);
                mail.setOrgWideEmailAddressId(orgWideAddressId);
                mail.setSaveAsActivity(true);
                mail.setUseSignature(false);
                mail.add(Mail);
            }
        } 
 }           */
}
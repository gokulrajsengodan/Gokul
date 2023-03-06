public class OpportunityCSVProcessor {
    
    @AuraEnabled
    public static DataWrapper csvFileRead(Id contentDocumentId){
       DataWrapper wrapper = new DataWrapper();
        
         List<String> csvRowDataList = new List<String>();
        List<String> headerList = new List<String>();
        Map<String,Integer> headerIndexMap = new Map<String,Integer>();
        Map<Opportunity,String> errFieldMap = new Map<Opportunity,String>();
        String csvHeader = '' ;  
      List<Opportunity_Field_Mapping__mdt> DDmapList = [
            SELECT Object__c, Field__c, Field__r.developerName, MasterLabel 
            FROM Opportunity_Field_Mapping__mdt
        ];    
        
        Set<String> contactNameList = new Set<String>();
        List<String> accNameList = new List<String>();
        List<String> strList1 = new List<String>();
        
        if(contentDocumentId != null) {
            
            ContentVersion contentVersionObj = [
                SELECT Id, VersionData 
                FROM ContentVersion 
                WHERE ContentDocumentId =:contentDocumentId
            ];
            
            String sd = contentVersionObj.VersionData.toString();
            System.debug('sd 1: ' + sd);
            System.debug('sd 2: ' + contentVersionObj.VersionData);
            String contents = '';
            List<String> sts = sd.split('');
            system.debug('sts --->'+sts);
            system.debug('sts --->'+sts.size());
            system.debug('sts --->'+sd.length());
            for(Integer i = 0; i < sd.length(); i++) {
                if(sts[i] == '\n') {
                    system.debug('empty -->');
                    if((i+1) <= sts.size() - 1) {
                        System.debug('sts[i] : ' + sts[i]+' --'+i);
                        System.debug('sts[i-1] : ' + sts[i-1]+' --'+i);
                        System.debug('sts[i+1] : ' + sts[i+1]+' --'+i);
                        if((sts[i-1].isAlphaSpace() || sts[i-1].isAlphanumericSpace() || sts[i-1].isAlpha() || sts[i-1].isAlphanumeric() || sts[i+1].isAlphaSpace() || sts[i+1].isAlpha() || 
                            sts[i+1].isAlphanumeric() || sts[i+1].isAlphanumericSpace())) {
                            contents += ' newline ';
                                system.debug('contents 1-->'+contents);
                        } else {
                            contents += sts[i];
                            system.debug('contents 2-->'+contents);
                        }
                    } else {
                        contents += sts[i];
                    }
                } else {
                    contents += sts[i];
                   // system.debug('sts[i] -->'+sts[i]);
                }
            }

            List<String> csvList = contents.split(Test.isRunningTest() ? 'newline' : '\n');
            System.debug('contents --> ' + contents);
            System.debug('Test.isRunningTest() --> ' + Test.isRunningTest());
            System.debug('csvList --> ' + csvList);
            System.debug('csvList size--> ' + csvList.size());
            System.debug('csvList size 1--> ' + csvList[0]);
            System.debug('csvList size 2--> ' + csvList[1]);
            Integer row = 0;
            System.debug('csvList Length: ' + csvList[0].split(';').size());
            System.debug('contents Length : ' + (csvList.size() == 1));
            if(csvList.size() == 1) {
                csvList = csvList[0].split('newline');
            }
            
            System.debug('contents : ' + csvList.size());
            for(String s : csvList) {
                csvList[row] = s.replaceAll('newline', '');
                System.debug(row + ' SSSS : ' + s);
                row++;
            }

            
            String sperator = csvList[0].split(',').size() > 2 ? ',' : ';';
            headerList = csvList[0].split(sperator);
            system.debug('HeaderList -->'+headerList);
            system.debug('HeaderList Size-->'+headerList.size());
            
            for(String header : headerList) { 
                Integer headerIndex = headerList.indexOf(header);
                system.debug('headerIndex -->'+headerIndex);
                system.debug('header -->'+header);
                Pattern nonAlphanumeric = Pattern.compile('[^a-zA-Z0-9]');
                Matcher matcher = nonAlphanumeric.matcher(header);
                String headName = matcher.replaceAll('');
                system.debug('nonAlphanumeric -->'+nonAlphanumeric);
                system.debug('matcher -->'+matcher);
                system.debug('headName -->'+headName);
                if(headName.length()>0){
                    headerIndexMap.put(headName,headerIndex);
                }
            }
            
            for(Integer i=1 ; i<csvList.size() ; i++) {
                if(csvList[i].replaceAll(',', '').length()<=1)
                    continue;
                csvRowDataList.add(csvList[i]);
                system.debug('Row ' + i + ' : '+csvList[i]);
            }
            
            System.debug('headerIndexMap:::: ' + headerIndexMap);
            System.debug('csvRowDataList:::: ' + csvRowDataList);

            for(String eachRow : csvRowDataList) {
                System.debug('eachRow : ' + eachRow);
                List<String> csvRowData = handleColumnComma(eachRow, sperator);
                System.debug('csvRowData : ' + csvRowData);
                if(csvRowData.size() > 1) {
                    Integer contactNameIndex = headerIndexMap.get('ContactName');
                    String contactName = csvRowData[contactNameIndex];
                    system.debug('contactNameIndex -->'+contactNameIndex);
                    system.debug('contactName -->'+contactName);
                    if(String.isEmpty(contactName) || String.isBlank(contactName)) {
                        wrapper.missingContactCount++;
                        continue;
                    } else {
                      contactNameList.add(contactName);  
                    } 
                    
                    Integer accNameIndex = headerIndexMap.get('AccountName');
                    String accName = csvRowData[accNameIndex];
                    if(accName != null && accName != ''){
                       accNameList.add(accName.trim());   
                    }
                    System.debug('accName : ' + accNameIndex);
                    System.debug('accName : ' + accName);
                }
            }
            system.debug('contactNameList: '+contactNameList.size());
            system.debug('accNameList: '+accNameList.size());
            
            Map<String,Contact> contactMap = new Map<String,Contact>();
            Map<String,Account> accountMap = new Map<String,Account>();
            List<Contact> insertConList = new List<Contact>();
            List<String> newContacts = new List<String>();
            
            if(accNameList.size()>0){
            for(Account acc : [
                SELECT Id, Name
				FROM Account
				WHERE Name IN : accNameList
            ]) {
                accountMap.put(acc.Name, acc);
            }
        }
            System.debug('accountMap : ' + accountMap);
            List<Contact> consToUpdate = new List<Contact>();
            if(!contactNameList.isEmpty()){
               for(Contact each : [select Id,Name,AccountId,Account.Name,CSV_Upload_Data_Review_Status__c from Contact where Name in:contactNameList]){
                    contactMap.put(each.Name, each);
                    if(each.CSV_Upload_Data_Review_Status__c <> 'Not Reviewed') {
                        each.CSV_Upload_Data_Review_Status__c ='Not Reviewed';
                        consToUpdate.add(each);
                    }
                }
                
                for(String conName : contactNameList){
                    if(!contactMap.containsKey(conName)){
                        System.debug('conName : ' + conName);
                        if(conName.indexOf(' ')>0 || String.isNotEmpty(conName)){
                            String firstName;
                            String lastName;
                            if(conName.split(' ').size() > 1) {
                                firstName = conName.substring(0,conName.indexOf(' '));
                                lastName = conName.substring(conName.indexOf(' ')+1);
                            } else {
                                lastName = conName;
                            }
                            System.debug('lastName : '+ lastName);
                            insertConList.add(new Contact(FirstName = firstName,
                                                          LastName = lastName, CSV_Upload_Data_Review_Status__c ='Not Reviewed'));
                            newContacts.add(conName);
                        }
                        else
                            wrapper.contactNameMismatchCount++;    
                    }
                }
            }
            system.debug('insertConList:'+insertConList);
            
            if(!insertConList.isEmpty()){
                insert insertConList;
            } 
            
            
            for(Contact each : [select Id,Name,AccountId,Account.Name,CSV_Upload_Data_Review_Status__c from Contact where Name in:newContacts]){
                contactMap.put(each.Name, each);
                if(each.CSV_Upload_Data_Review_Status__c <> 'Not Reviewed') {
                    each.CSV_Upload_Data_Review_Status__c ='Not Reviewed';
                    consToUpdate.add(each);
                }
            }
            if(!consToUpdate.isEmpty()) {
                update consToUpdate;
            }
            
            String sObjectName = 'Opportunity';
            Map<String, Schema.SObjectField> schemaSObjectField = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
            Map<String, Schema.DescribeFieldResult> fieldDescriptionMap = new Map<String, Schema.DescribeFieldResult>();
            for( String fieldName : schemaSObjectField.keySet() ) {
                Schema.DescribeFieldResult fieldDescription = schemaSObjectField.get( fieldName ).getDescribe();
                fieldDescriptionMap.put(fieldDescription.getLabel(), fieldDescription);
            }
            
            List<Opportunity> oppList = new List<Opportunity>();
            for(String eachRow : csvRowDataList){
                List<String> csvRowData = handleColumnComma(eachRow, sperator);
                System.debug('HKK1 : ' + eachRow);
                System.debug('HKK2 : ' + csvRowData);
                Contact con = contactMap.get(csvRowData[headerIndexMap.get('ContactName')]);
                String closeDate = csvRowData[headerIndexMap.get('CloseDate')];
                Opportunity opp = new Opportunity();
                if(con <> null){
                    for(Opportunity_Field_Mapping__mdt mdt : DDmapList){
                        Integer headerIndex = headerIndexMap.get( mdt.MasterLabel);
                        if(headerIndex <> null && csvRowData[headerIndex] <> null && csvRowData[headerIndex] <> ''){
                            Schema.DescribeFieldResult fieldDescription = fieldDescriptionMap.get(mdt.Field__r.developerName);
                            Object value = convertToType(csvRowData[headerIndex], fieldDescription.getType(), wrapper);
                            if(value!=null)
                                opp.put(fieldDescription.getName() , value);
                        }                    
                    }
                    Account acc = !accountMap.isEmpty() && accountMap.containsKey(csvRowData[headerIndexMap.get('AccountName')].trim()) ? accountMap.get(csvRowData[headerIndexMap.get('AccountName')].trim()) : null;
                    System.debug('Account : ' + accountMap.get(csvRowData[headerIndexMap.get('AccountName')].trim()));
                    opp.AccountId = acc <> null ? acc.Id : con.AccountId;
                    opp.ContactId = con.Id;
                    opp.StageName = 'Closed Won';
                    opp.CSV_Data_Upload__c = true;
                    if(closeDate <> null && closeDate <> ''){
                        opp.CloseDate =(Date)convertToType(closeDate, Schema.DisplayType.Date , wrapper);
                    }
                    errFieldMap.put(opp,eachRow.replace('\r',''));
                    oppList.add(opp);
                }
            }
            system.debug('oppList:'+oppList);
            try{
                //if(!oppList.isEmpty() && wrapper.missingContactCount == 0 && wrapper.contactNameMismatchCount ==0 &&  !wrapper.dateMismatch){
                    Database.SaveResult[] results = database.insert(oppList,false);
                    
                    Boolean flag = false;
                	csvHeader = '';
                    for(String str:headerList) {
                        System.debug('str:::'+str);
                        csvHeader += str + ',';
                    }
                    csvHeader += 'Status,Error';
                	csvHeader = csvHeader.replace('\r','');
                	system.debug('csvHeader:: '+csvHeader);
                    for (Database.SaveResult sr : results) {
                        if (!sr.isSuccess()) {
                            csvHeader += '\n';
                            Integer resIndex = results.indexOf(sr);
                            Opportunity oppObject = oppList[resIndex];
                            csvHeader += errFieldMap.get(oppObject);
                            flag = true;
                            csvHeader += ',Error,'+sr.getErrors()[0].getMessage();
                        }
                    }
                	system.debug('csvHeader2:: '+csvHeader);
                    if(flag) {
                        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                        blob csvBlob = Blob.valueOf(csvHeader);
                        csvAttc.setFileName('Donations.csv');
                        csvAttc.setBody(csvBlob);
                        Messaging.SingleEmailMessage errEmail =new Messaging.SingleEmailMessage();
                        errEmail.setSubject('Error Records');
                        errEmail.setToAddresses(new List<String>{Label.Opportunity_CSV_Upload_Error_Receipient_Email});
                        errEmail.setPlainTextBody('Donations Error CSV file');
                        errEmail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                        system.debug('errEmail:: '+errEmail);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {errEmail});
                    }
                //}
            }
            catch(Exception e){
                //wrapper.status = 'Failed to create Donars and Donations.';
                system.debug('Exception: Type='+e.getTypeName()+' Message='+e.getMessage());
                String message = e.getMessage();
                if(message.contains('REQUIRED_FIELD_MISSING'))
                    wrapper.status = 'Required field(s) are missing ['+message.substring(message.indexOf('[')+1, message.indexOf(']'))+'] \n';
                else
                    wrapper.status = e +'';
            }
            if(wrapper.missingContactCount > 0){
                //wrapper.status = wrapper.status <> null ? wrapper.status+'\n' : null;
                wrapper.status = wrapper.status + wrapper.missingContactCount + ' row(s) are missing Donor details. \n';
            }
            if(wrapper.contactNameMismatchCount > 0){
                //wrapper.status = wrapper.status <> null ? wrapper.status+'\n' : null;
                wrapper.status = wrapper.status + wrapper.contactNameMismatchCount + ' row(s) are not having Donar\'s last name. Please add a space between first name and last name to differentiate last name. \n';
            }
            if(wrapper.dateMismatch){
                //wrapper.status = wrapper.status <> null ? wrapper.status+'\n' : null;
                wrapper.status = wrapper.status + 'Date format should be in YYYY-MM-DD format. \n';
            }
        }    
        
        return wrapper;
    }
    
    public static List<String> handleColumnComma(String csvLine, String sperator) {
        String prevLine = csvLine;
        Integer startIndex;
        Integer endIndex;
        while(csvLine.indexOf('"') > -1){
            system.debug('handleColumnComma -->'+csvLine.indexOf('"'));
            if(startIndex == null){
                startIndex = csvLine.indexOf('"');
                csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
            }else{
                if(endIndex == null){
                    endIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                }
            }
            
            if(startIndex != null && endIndex != null){
                String sub = csvLine.substring(startIndex, endIndex);
                sub = sub.replaceAll(',', ':comma:');
                csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                startIndex = null;
                endIndex = null;
            }
        }
        
        System.debug('prevLine:::'+prevLine);
        System.debug('csvLine:::'+csvLine);
        List<String> columns = new List<String>();
        for(String column : csvLine.split(sperator)){
            column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
            System.debug('column::'+column);
            columns.add(column);
        }
        return columns;
    }
    
    public static Object convertToType(String value, Schema.DisplayType type, DataWrapper wrapper) {
        Object obj = value;
        if(type == Schema.DisplayType.Integer){
            obj = Integer.valueOf(value);
        }
        else if(type == Schema.DisplayType.Double){
            obj =  Decimal.valueOf(value);
        }
        else if(type == Schema.DisplayType.Date){
            try {
              //  value = value.replaceAll('\'', '');
                value = value.replace('\n', '');
                List<String> dds = value.contains('.') ? value.split('\\.') : value.split('\\/');
                system.debug('Value -->'+value);
                system.debug('Value -->'+dds +'  '+dds.size());
                obj =  Date.parse(dds[2] + '/' + dds[1] + '/' + dds[0]);
                system.debug('Object -->'+obj);
            }
            catch(TypeException e) {
                wrapper.dateMismatch = true;
                return null;
            }
        }
        else if(type == Schema.DisplayType.DateTime){
            obj =  Date.parse(value);
        }
        else if(type == Schema.DisplayType.Boolean){
            obj =  Boolean.valueOf(value);
        }
        else if(type == Schema.DisplayType.String 
                || type == Schema.DisplayType.Id
                || type == Schema.DisplayType.Email
                || type == Schema.DisplayType.Reference
                || type == Schema.DisplayType.TextArea
                || type == Schema.DisplayType.URL
                || type == Schema.DisplayType.Picklist
                || type == Schema.DisplayType.Phone)
        {
            obj =  value;
        }
        //Schema.DisplayType doesn't have Decimal enum type and Decimal is not captured in Double type
        else
            obj =  Decimal.valueOf(value.replaceAll(',', '').replaceAll('\t', ''));
        return obj;
    }
    
    public class DataWrapper{
        
        @AuraEnabled public String status='';
        @AuraEnabled public Integer missingContactCount = 0;
        @AuraEnabled public Integer contactNameMismatchCount = 0;
        @AuraEnabled public Boolean dateMismatch = false;
        
    }
}
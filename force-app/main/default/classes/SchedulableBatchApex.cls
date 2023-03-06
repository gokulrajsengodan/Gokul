global class SchedulableBatchApex implements Database.Batchable<Sobject>,Database.Stateful{

     global Integer recordsProcessed = 0;
     global  database.QueryLocator start(database.BatchableContext bc){
        return database.getQueryLocator('select id,CloseDate from opportunity where CloseDate !=null');
    }
    global void execute(database.BatchableContext bc,List<Opportunity>scope){
        for(Opportunity le:scope){
            if(le.CloseDate <= system.today()){
                le.StageName ='Closed Won';
                recordsProcessed = recordsProcessed + 1;
                
            }
        }
        update scope;
    }
    global void finish(database.BatchableContext bc){
        
    }
}
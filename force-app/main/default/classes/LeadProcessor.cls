global class LeadProcessor implements database.Batchable<Sobject>, Database.Stateful{
     global Integer recordsProcessed = 0;
    global  database.QueryLocator start(database.BatchableContext bc){
        return database.getQueryLocator('select id,LeadSource From lead');
    }
    global void execute(database.BatchableContext bc,List<lead>scope){
        for(lead le:scope){
            le.LeadSource='Dreamforce';
              recordsProcessed = recordsProcessed + 1;
        }
        update scope;
    }
    global void finish(database.BatchableContext bc){
         System.debug(recordsProcessed + ' records processed. Shazam!');
    }
}
global class OppSchedulable implements Schedulable{
    global void execute(Schedulablecontext sc){
         SchedulableBatchApex b = new SchedulableBatchApex();
        Database.executeBatch(b);
        
    }

}
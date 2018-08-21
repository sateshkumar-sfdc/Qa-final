global class LeadRecordsBatchScheduler implements schedulable{
    global void execute(SchedulableContext sc)
    {
    LeadRecordsBatch LeadRecordsBatchProcessor = new LeadRecordsBatch(); //ur batch class
      database.executebatch(LeadRecordsBatchProcessor,200);
    }  
}
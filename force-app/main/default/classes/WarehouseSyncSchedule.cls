public with sharing class WarehouseSyncSchedule implements Schedulable{
    // implement scheduled code here
    public void execute(SchedulableContext sc){
        ID jobID = System.enqueueJob(new WarehouseCalloutService());
        System.debug('job id: ' + jobID);
    }
}
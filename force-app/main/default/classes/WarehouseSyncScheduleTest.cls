@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    @isTest static void testScheduleJob(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        List<Product2> equipmentRec = new List<Product2>();
        System.assertEquals(0, [SELECT ID FROM Product2].size(),'There are no Equipment records created yet.');
        Test.startTest();
        Id JobID = System.Schedule('WarehouseSyncScheduleJobTest', '0 0 1 * * ?', new WarehouseSyncSchedule());
        System.debug([SELECT ID,CronExpression,CronJobDetailId FROM CronTrigger]);
        CronTrigger crn = [SELECT ID,CronExpression FROM CronTrigger WHERE Id =: JobID];
        System.assertEquals('0 0 1 * * ?', crn.CronExpression,'Cron job should be scheduled to run at 1AM.');
        Test.stopTest();
    }
}
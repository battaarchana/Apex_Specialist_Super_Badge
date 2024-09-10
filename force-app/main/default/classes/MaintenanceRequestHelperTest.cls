@isTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here
    @isTest static void testUpdateWorkOrders(){
        CreateDefaultData.createDefaultData();
        List<Vehicle__c> vehicles = [SELECT ID FROM Vehicle__c];
        List<Product2> equipments = [SELECT ID FROM Product2];
        List<Case> maintenanceRequests = [SELECT ID FROM Case];
        List<Equipment_Maintenance_Item__c> equipmentMaintenanceItems = [SELECT ID FROM Equipment_Maintenance_Item__c];
        //Test.startTest();

        System.assertEquals(4, vehicles.size(),'There should have been 4 vehicles created');
        System.assertEquals(4, equipments.size(), 'There should have been 4 equipments created');
        System.assertEquals(2, maintenanceRequests.size(), 'There should have been 2 maintenance Requests created');
        System.assertEquals(6, equipmentMaintenanceItems.size(), 'There should have been 6 equipment maintenance items created');

        maintenanceRequests[0].Status = 'Closed';
        Database.update(maintenanceRequests[0]);

        List<Case> maintenanceRequestsLatest = [SELECT ID FROM CASE];
        System.assertEquals(3, maintenanceRequestsLatest.size(), 'There should have been 1 new maintenance Request created');
        //Test.stopTest();
    }
    
    @isTest static void testNullCheck(){
        MaintenanceRequestHelper.updateWorkOrders();
        
        MaintenanceRequestHelper.createEquipmentMaintenanceItem();
    }
}
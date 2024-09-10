@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @IsTest static void testEquipmentQueuable(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        List<Product2> equipmentRec = new List<Product2>();
        System.assertEquals(0, [SELECT ID FROM Product2].size(),'There are no Equipment records created yet.');
        Test.startTest();
        System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
        System.assertEquals(4, [SELECT ID FROM Product2].size(),'There are 4 Equipment records created.');
    }
}
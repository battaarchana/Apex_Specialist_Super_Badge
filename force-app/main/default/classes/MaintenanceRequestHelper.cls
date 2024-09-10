public with sharing class MaintenanceRequestHelper {
    public static List<Case> futureMaintenanceRequestList = new List<Case>();
    static Map<Id,Integer> maintenanceCylePerCase = new Map<Id,Integer>();
    static Map<Id,Case> oldVsNewCasMap = new Map<Id,Case>();

    public static void updateWorkOrders() {
        // TODO: Complete the method to update workorders
        if(futureMaintenanceRequestList == null || futureMaintenanceRequestList.isEmpty()){
            return;
        }
        //Calculate Minimum maintenance cycle for each Maintenance request
        calculateDueDate();
    }

    static void calculateDueDate(){
        Set<ID> caseIDSet = new Set<ID>((new Map<ID,Case>(futureMaintenanceRequestList)).keySet());
        for(AggregateResult agr :[SELECT MIN(Equipment__r.Maintenance_Cycle__c) mincycle,Maintenance_Request__c FROM Equipment_Maintenance_Item__c 
                                    WHERE Maintenance_Request__c IN :caseIDSet GROUP BY Maintenance_Request__c]){
            maintenanceCylePerCase.put(String.valueOf(agr.get('Maintenance_Request__c')),Integer.valueOf(agr.get('mincycle')));
        }

        //Create New Mainteance Requests
        createMaintenanceRequest();
    }

    static void createMaintenanceRequest(){
        List<Case> futureRequestList = new List<Case>();
        for(Case cs : futureMaintenanceRequestList){
            Case newCase = new Case();
            newCase.Vehicle__c = cs.Vehicle__c;
            newCase.Type = 'Routine Maintenance';
            newCase.Subject = 'Routine Maintenance Request';
            newCase.Date_Reported__c = System.today();
            if(maintenanceCylePerCase != null && maintenanceCylePerCase.containsKey(cs.Id)){
                newCase.Date_Due__c = System.today().addDays(maintenanceCylePerCase.get(cs.Id));
            }
            futureRequestList.add(newCase);
            oldVsNewCasMap.put(cs.Id,newCase);
        }

        If(oldVsNewCasMap != null && oldVsNewCasMap.size() > 0){
            Database.insert(futureRequestList);
            //Database.insert(oldVsNewCasMap.values());
            //Create Maintenance Item records
            createEquipmentMaintenanceItem();
        }
    }

    PUBLIC static void createEquipmentMaintenanceItem(){
        if(oldVsNewCasMap == null || oldVsNewCasMap.isEmpty()){
            return;
        }

        List<Equipment_Maintenance_Item__c> newEquipmentMaintenanceItemList = new List<Equipment_Maintenance_Item__c>();
        for(Equipment_Maintenance_Item__c emainItem : [SELECT Equipment__c,Maintenance_Request__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :oldVsNewCasMap.keySet()]){
            Equipment_Maintenance_Item__c newEMItem = new Equipment_Maintenance_Item__c();
            newEMItem.Equipment__c = emainItem.Equipment__c;
            newEMItem.Maintenance_Request__c = oldVsNewCasMap.get(emainItem.Maintenance_Request__c).Id;
            newEquipmentMaintenanceItemList.add(newEMItem);
        }

        If(newEquipmentMaintenanceItemList != null && newEquipmentMaintenanceItemList.size() > 0){
            Database.insert(newEquipmentMaintenanceItemList);
        }
    }
    
}
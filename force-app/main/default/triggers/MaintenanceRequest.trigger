trigger MaintenanceRequest on Case (after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    List<Case> futureMaintenanceRequestList = new List<Case>();
    for(Case cs : Trigger.New){
        Case oldCs = Trigger.oldMap.get(cs.Id);
        if(String.isNotBlank(cs.Type) && (cs.Type.equalsIgnoreCase('Repair') || cs.Type.equalsIgnoreCase('Routine Maintenance')) && 
          !oldCs.Status.equals(cs.Status) && String.isNotBlank(cs.Status) && cs.Status.equalsIgnoreCase('Closed')){
            futureMaintenanceRequestList.add(cs);
        }
    }
    
    if(futureMaintenanceRequestList != null && futureMaintenanceRequestList.size() > 0){
        MaintenanceRequestHelper.futureMaintenanceRequestList = futureMaintenanceRequestList;
        MaintenanceRequestHelper.updateWorkOrders();
    }
}
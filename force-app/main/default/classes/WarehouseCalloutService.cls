public with sharing class WarehouseCalloutService implements Queueable,Database.AllowsCallouts{

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    public void execute(QueueableContext qc){
        List<Product2> equipmentToUpsert = new List<Product2>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            List<Object> responseList = (List<Object>)(JSON.deserializeUntyped(response.getBody()));
            for(Object resp : responseList){
                System.debug(resp);
                Map<String,Object> obj = (Map<String,Object>) resp;
                Product2 pd = new Product2();
                pd.Replacement_Part__c = (Boolean) obj.get('replacement');
                pd.Cost__c = (Decimal)obj.get('cost');
                pd.Current_Inventory__c = (Double) obj.get('quantity');
                pd.Lifespan_Months__c =(Integer)  obj.get('lifespan');
                pd.Maintenance_Cycle__c = (Integer) obj.get('maintenanceperiod');
                pd.Warehouse_SKU__c = (String) obj.get('sku');
                pd.Name = (String) obj.get('name');
                equipmentToUpsert.add(pd);
            }
        }

        if(equipmentToUpsert != null && !equipmentToUpsert.isEmpty()){
            Database.upsert(equipmentToUpsert);
        }
    }
    
}
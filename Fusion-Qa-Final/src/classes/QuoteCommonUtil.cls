public class QuoteCommonUtil {
   public static String expireQuote(Id recordId) {
     try {
         Quote_Header__c QuoObj = [Select Id, Status__c From Quote_Header__c where Id =: recordId];
         QuoObj.Status__c = 'Expired';
         update QuoObj;
         return 'SUCCESS';
     } catch (Exception e){
         System.debug('An unexpected error has occurred: ' + e.getMessage());
         return e.getMessage();
       }
     }
    
     public static List<String> getSobjectFields(String Objectname){
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(Objectname.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         system.debug(selectFields);
      return selectFields;  
    }

}
public class FileController {
    
      
    @AuraEnabled
    public static List<FileDataWrapper> saveTheFile(String parentId, String fileName, String base64Data, String contentType) { 
        System.debug('fileName==>'+fileName);
        System.debug('contentType==>'+contentType);
        system.debug('base64Data----->'+base64Data);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        String[] filelines = new String[]{};
        string nameFile ;
         List<FileDataWrapper> fileDataWrapperList = new List<FileDataWrapper>();
        
            nameFile= blobToString(EncodingUtil.base64Decode(base64Data),'ISO 8859-1');      
            filelines = nameFile.split('\n');       
      /*  
        Date d = date.today();
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYY-MM-dd');
        ProductSearch Ps = new ProductSearch();
        List<ProductSearch.Item> itmlist = new List<ProductSearch.Item>();
        ProductSearch.PRODUCTS products = new ProductSearch.PRODUCTS();
        */
        List<String> productlist = new List<String>();
		map<String,FileDataWrapper> materialFDWMap= new map<String,FileDataWrapper>();
            for(Integer i=1;i<filelines.size()-1;i++){
               
               String[] inputvalues = new String[]{};            
               inputvalues = filelines[i].split(',');
               system.debug('%%%%%%% each Line::::: '+filelines.size() );
                
                
                
              /*  ProductSearch.Item Itm = new ProductSearch.Item();
                Itm.MATERIAL = inputvalues[0];
                Itm.PLANT = '';
                itmlist.add(Itm);
                */
                
                FileDataWrapper fdw = new FileDataWrapper();
                fdw.MaterialID = inputvalues[0];
                fdw.productName = inputvalues[1];
                fdw.productKey = inputvalues[2];
                fdw.upk = inputvalues[3];
                fdw.productCategory = inputvalues[4];
                fdw.customizableFlag = inputvalues[4];
                fdw.heirarchy = inputvalues[5];
                fdw.imageUrl = inputvalues[6];
                
                materialFDWMap.put(fdw.MaterialID,fdw);
                productlist.add(inputvalues[0]);
               /* fdw.royaltyRate = inputvalues[7];
                fdw.itemKeyId = inputvalues[8];*/
                fileDataWrapperList.add(fdw);
              //  system.debug('wrapper list-->'+itm);
            }
        
        ProductServiceRequestApex.AvailabilityWrapper Aw = new ProductServiceRequestApex.AvailabilityWrapper();
        Aw.salesoffice = 'STD';
        Aw.salesOrg = '1100';
        Aw.salesgrp = 'STD';
        Aw.division = '10';
        Aw.distribution = '10';
        Aw.productMaterial = productlist;
		String materialStr = JSON.serialize(Aw);
		system.debug('test string-->'+materialStr);  
        system.debug('callout result-->'+ProductServiceRequestApex.checkAvailability(materialStr));
         /*   products.item = itmlist;
            Ps.PRODUCTS = products;
            Ps.CUSTOMER = '';
        	Ps.SALES_ORG = '1100';
            Ps.DISTR_CHAN = '10'; 
            Ps.DIVISION = '10';
			Ps.SALES_GRP = 'STD';
			Ps.SALES_OFF =  'STD';
        	Ps.PRICE_DATE = dt;
             system.debug('Test Request-->'+Ps);
            string request = JSON.serialize(Ps);
            String JsonResponse;
            JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_Availability', request, 'POST');
            system.debug('replace string-->'+JsonResponse.replace('RETURN', 'RETURN_Z'));
             system.debug('wrapper list 1-->'+fileDataWrapperList.size());*/
             return fileDataWrapperList;
    }
    
     @AuraEnabled
        public static string uploadQuoteItems(String recId,string fileWrapper)
        {
            system.debug('hello--->'+fileWrapper);
             List<FileDataWrapper> fileList = (List<FileDataWrapper>)JSON.deserialize(fileWrapper,List<FileDataWrapper>.class);
            for(FileDataWrapper fdw : fileList)
            {
                system.debug('--list--'+fdw);
            }
            return null;
        }
    
    public static String blobToString(Blob input, String inCharset){ 
    String hex = EncodingUtil.convertToHex(input); 
    System.assertEquals(0, hex.length() & 1);
    final Integer bytesCount = hex.length() >> 1; 
    String[] bytes = new String[bytesCount]; 
    for(Integer i = 0; i < bytesCount; ++i) bytes[i] = hex.mid(i << 1, 2); 
    return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset); }
    
    public class FileDataWrapper 
    {
        @AuraEnabled Public String MaterialID {get;set;}  
        @AuraEnabled Public String productName {get;set;}
        @AuraEnabled Public String productKey {get;set;}
        @AuraEnabled Public String upk {get;set;}     
        @AuraEnabled Public String productCategory {get;set;} 
        @AuraEnabled Public String customizableFlag {get;set;}
		@AuraEnabled Public String heirarchy {get;set;}
        @AuraEnabled Public String imageUrl {get;set;}  
        @AuraEnabled Public String quantity {get;set;}
        @AuraEnabled Public String errorMessage {get;set;} 
        @AuraEnabled Public Double COND_VALUE {get;set;} 
       /* @AuraEnabled Public String royaltyRate {get;set;}     
        @AuraEnabled Public String itemKeyId {get;set;}*/

    }

    
}
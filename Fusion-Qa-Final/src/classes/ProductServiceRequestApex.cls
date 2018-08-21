public class ProductServiceRequestApex {
    @AuraEnabled
    public Static String checkAvailability(String materialStr)
    {
        Date d = date.today();
        String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYY-MM-dd');
        //system.debug(dt);
        
        ProductSearch Ps = new ProductSearch();
        List<ProductSearch.Item> itmlist = new List<ProductSearch.Item>();
        ProductSearch.PRODUCTS products = new ProductSearch.PRODUCTS();
        system.debug('--test'+materialStr);
         
       // if(materialStr != null && materialStr !='')
       // { 
            String usrCountry;
        	String slsOrg;
        	String cmpCode;
        	String defaultDistDiv;
            AvailabilityWrapper availWrapper = (AvailabilityWrapper)JSON.deserialize(materialStr, AvailabilityWrapper.class);
          /*  String usrCountry = [Select country From User Where Id = :UserInfo.getUserId()][0].country; 
            if(usrCountry == null || usrCountry == '')
            {
                usrCountry = 'US';
            }
            if(usrCountry == 'US')
                usrCountry = usrCountry+System.Label.Default_Us_Sales_Org;
            //Country_SalesOrg_CompanyCode__c csc = new Country_SalesOrg_CompanyCode__c();
            String slsOrg = Country_SalesOrg_CompanyCode__c.getInstance(usrCountry).Sales_Org__C;
            String cmpCode = SalesOrg_CompanyCode__c.getInstance(slsOrg).Company_Code__c;
            String defaultDistDiv = System.Label.Default_Distribution_Division;*/
            //Map<String,Country_SalesOrg_CompanyCode__c> countrySeedDataMap = Country_SalesOrg_CompanyCode__c.getInstance(usrCountry);
            for(String str : availWrapper.productMaterial)
            {
                ProductSearch.Item Itm = new ProductSearch.Item();
                Itm.MATERIAL = str;
                Itm.PLANT = '';
                
                itmlist.add(Itm);
            }        
            products.item = itmlist;
            Ps.PRODUCTS = products;
            Ps.CUSTOMER = '';
        system.debug('sls-->'+!String.isEmpty(availWrapper.salesOrg));
            
                if(!String.isEmpty(availWrapper.salesOrg)){
                    
                 Ps.SALES_ORG = availWrapper.salesOrg;
                 Ps.DISTR_CHAN = availWrapper.distribution; 
            	 Ps.DIVISION = availWrapper.division;
                 
                }
        else {
            
			    usrCountry = [Select country From User Where Id = :UserInfo.getUserId()][0].country; 
                system.debug('-->ctry'+usrCountry);
                if(usrCountry == null || usrCountry == '')
                {
                    usrCountry = 'US';
                }
                if(usrCountry == 'US')
                    usrCountry = usrCountry+'-'+System.Label.Default_Us_Sales_Org;
                //Country_SalesOrg_CompanyCode__c csc = new Country_SalesOrg_CompanyCode__c();
                
             	system.debug('else test-->'+usrCountry+'-->'+Country_SalesOrg_CompanyCode__c.getInstance(usrCountry).Sales_Org__C);
                slsOrg = Country_SalesOrg_CompanyCode__c.getInstance(usrCountry).Sales_Org__C;
                cmpCode = SalesOrg_CompanyCode__c.getInstance(slsOrg).Company_Code__c;
                defaultDistDiv = System.Label.Default_Distribution_Division;
                Ps.SALES_ORG = slsOrg;
                Ps.DISTR_CHAN = defaultDistDiv; 
            	Ps.DIVISION = defaultDistDiv;
                system.debug('else test-->1'+System.Label.Default_Distribution_Division);

                       }
                
            
            Ps.PRICE_DATE = dt;
            if(!String.isEmpty(availWrapper.salesgrp))
                Ps.SALES_GRP = availWrapper.salesgrp;
            else
                Ps.SALES_GRP = System.Label.Default_SalesOffice_SalesOrg;
        
        system.debug('--->1'+!String.isEmpty(availWrapper.salesoffice)+'def-->'+System.Label.Default_SalesOffice_SalesOrg);
            if(!String.isEmpty(availWrapper.salesoffice))
                Ps.SALES_OFF = availWrapper.salesoffice;
            else
                Ps.SALES_OFF = System.Label.Default_SalesOffice_SalesOrg;
            /*Ps.SALES_OFF = availWrapper.salesoffice;
Ps.SALES_ORG = availWrapper.salesOrg;*/
      //  }
     /*   else{
            ProductSearch.Item Itm = new ProductSearch.Item();
            Itm.MATERIAL = '10105010000';
            //Itm.PLANT = '';
            itmlist.add(Itm);
            products.item = itmlist;
            Ps.PRODUCTS = products;
            Ps.CUSTOMER = '';
            Ps.DISTR_CHAN = '10'; 
            Ps.DIVISION = '10';
            Ps.PRICE_DATE = dt;
            Ps.SALES_GRP = 'STD';
            Ps.SALES_OFF = 'STD';
            Ps.SALES_ORG = '1100';
        }*/
        system.debug('Test Request-->'+Ps);
        string request = JSON.serialize(Ps);
        
        String JsonResponse;
        JsonResponse = CommonServiceApiUtil.sendApiRequest('callout:SAP_PI_Availability', request, 'POST');
        system.debug('replace string-->'+JsonResponse.replace('RETURN', 'RETURN_Z'));
        JsonResponse = JsonResponse.replace('RETURN', 'RETURN_Z');
        String responseString;
        ProductSearchResponse wrapper;
        ResultParser resultWrap;
        system.debug('json response->'+JsonResponse);
        try{
            wrapper =(ProductSearchResponse)JSON.deserialize(JsonResponse,ProductSearchResponse.class);
        }
        catch(exception e)
        {
            system.debug('exception-->'+e.getMessage());
            if(e.getMessage().contains('Expected ProductSearchResponse.PRODUCT_LIST but found ""'))
            {
                resultWrap = (ResultParser)JSON.deserialize(JsonResponse, ResultParser.class);
                system.debug('222--->'+resultWrap);
            }
        }
        AvailabilityResponseWrapper respWrapper = new AvailabilityResponseWrapper();
        List<AvailabilityResponseWrapper> respWrapperList = new List<AvailabilityResponseWrapper>();
        if(wrapper != null){
            system.debug('Result-->'+wrapper.PRODUCT_LIST);
            system.debug('error--'+wrapper.PRODUCT_LIST.item);
            for(ProductSearchResponse.Item_Z Itmz : wrapper.PRODUCT_LIST.item )
            {	
                //respWrapper.ITM_NUMBER = Itmz.ITM_NUMBER;
                //respWrapper.PLANT = Itmz.PLANT;
                //respWrapper.STGE_LOC = Itmz.STGE_LOC;
                respWrapper.MATERIAL = Itmz.MATERIAL;
                respWrapper.SHORT_TEXT = Itmz.SHORT_TEXT;
                respWrapper.QTY_AVAILABLE = Itmz.QTY_AVAILABLE;
                for(ProductSearchResponse.Item pricing : Itmz.PRICING.item)
                {
                    /* PricingResponseWrapper PRW = new PricingResponseWrapper();
                    PRW.COND_DESC = pricing.COND_DESC;
                    PRW.CONDVALUE = pricing.CONDVALUE;
                    PRW.COND_TYPE = pricing.COND_TYPE;
                    respWrapper.PricingList.add(PRW);*/
                    if(pricing.COND_DESC == 'Price')
                    {
                        respWrapper.COND_DESC =  pricing.COND_DESC;
                        respWrapper.COND_VALUE = pricing.COND_VALUE;
                    }
                }
                
                respWrapperList.add(respWrapper);
            }
        }
        else if(resultWrap != null)
        {
            system.debug('----111>'+resultWrap);
            for(ResultParser.ItemR res : resultWrap.RETURN_Z.item)
            {
                system.debug('error message-->'+res.MESSAGE);
                respWrapper.errorMessage = res.MESSAGE;
                respWrapperList.add(respWrapper);
            }
        }
        system.debug('returnList--->'+JSON.serialize(respWrapperList));
        if(respWrapperList.size()>0)
            responseString = JSON.serialize(respWrapperList);
        return responseString;
    }
    
    public with sharing class AvailabilityWrapper {
        public String salesoffice;
        public String salesOrg;
        public String salesgrp;
        public String division;
        public String distribution;
        public List<String> productMaterial; 
        // public String Customer;
    }
    
    public with sharing class AvailabilityResponseWrapper {
        //public List<ProductSearchResponse.Item_Z> availabilityItemsList;
        //public String ITM_NUMBER;
        //public Integer PLANT;
        //public Integer STGE_LOC;
        public Long MATERIAL;
        public String SHORT_TEXT;
        public String QTY_AVAILABLE;
        public Double COND_VALUE;
        public String COND_DESC;
        public String errorMessage;
        //Public List<PricingResponseWrapper> PricingList = new List<PricingResponseWrapper>();
        // public String Customer;
        
    }   
    /*public with sharing class PricingResponseWrapper {
//public List<ProductSearchResponse.Item_Z> availabilityItemsList;
public String COND_DESC;
public Double COND_VALUE;
public String COND_TYPE;

}
    public static List<String> OrderUpda(JSONParser parser) {
        List<String> responseType = new List<string>();	
        while (parser.nextToken() != null) {
            system.debug('JSON Token-->'+parser.getText()+'--'+System.JSONToken.FIELD_NAME);
            
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                
                system.debug('tex'+text);
                if (text == 'TYPE' && parser.nextToken() != null) {
                    //if (text == 'TYPE') {
                    system.debug('Type-->'+parser.getText());
                    responseType.add(parser.getText());
                    //} 
                }
            }
        }
        return responseType;
    }   */ 
}
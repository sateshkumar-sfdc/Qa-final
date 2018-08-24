public class GetPrices_Quote {
    
    @AuraEnabled
    public Static String getModifiedStructurePrices(String request){
        String pricingRequest = request;
        String actualJson = getPrices(pricingRequest);
        System.JSONParser parser = System.JSON.createParser(actualJson);
                List<String> responseList = OrderUpda(parser);
                if (responseList.size()>0) {
                    
                    Map<String, Object> initObj = new Map<String, Object>{'MESSAGE' => responseList[0]};
                    system.debug('---@@@@'+initObj);
        		    //List<Object> item = (List<Object>)((Map<String, Object>)initObj.get('MESSAGE'));
                    
                    system.debug('response type----->'+responseList);
                    system.debug('modified --->'+JSON.serialize(initObj));
                    return JSON.serialize(initObj);
                    /*
                     Map<String, Object> initObj = (Map<String, Object>)JSON.deserializeUntyped(actualJson);
        			 List<Object> item = (List<Object>)(initObj.get('RETURN')).get('item');
                     List<Object> itemError = (List<Object>)(initObj.get('MESSAGE'));
        			 //List<Object> itemObjItem = new List<Object>();
                     system.debug('modified --->'+JSON.serialize(itemError));
                     return JSON.serialize(itemError);*/
                }
                else{
                  Map<String, Object> initObj = (Map<String, Object>)JSON.deserializeUntyped(actualJson);
        List<Object> item = (List<Object>)((Map<String, Object>)initObj.get('ORDER_PRICING')).get('item');
        
        for(Object obj : item){
            Map<String, Object> itemObj = (Map<String, Object>)obj;
            if(itemObj.containsKey('PRICING')){
                List<Object> itemObjItem = (List<Object>)((Map<String, Object>)itemObj.get('PRICING')).get('item');
                itemObj.put('PricingList',itemObjItem);
                itemObj.remove('PRICING');
            }
        }
        system.debug('modified --->'+JSON.serialize(item));
        return JSON.serialize(item);
                }
        
    }
    
    @AuraEnabled
    public Static String getPrices(String pricingRequest){
        try{
            String format = pricingRequest.replace('MaterialID__c', 'MaterialID');
            GetPrice_RequestFromCmp req = (GetPrice_RequestFromCmp) JSON.deserialize(format,GetPrice_RequestFromCmp.class);
            system.debug('req--->'+req);
            
            String usrCountry;
            String slsOrg;
            String cmpCode;
            String defaultDistDiv;
            Date d = date.today();
        	String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('YYYY-MM-dd');
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            Map<String,Object> reqBody = new Map<String,Object>();
           // Object OrderHeader= JSON.deserializeUntyped('{"DOC_TYPE":"OR","SALES_ORG":"1100","DISTR_CHAN":"10","DIVISION":"10","SALES_GRP":"STD","SALES_OFF":"STD","REQ_DATE_H":"20180820","PRICE_DATE":"20180820"}');
            Map<String,Object> mapObObj=new Map<String,Object>();
            Map<String,String> item=new Map<String,String>();
            List<Object> items=new List<Object>();
            item=new Map<String,String>();
            item.put('DOC_TYPE','TA');
            
            
             if(!String.isEmpty(req.salesOrg)){
                 item.put('SALES_ORG',req.salesOrg);
                item.put('DISTR_CHAN',req.distribution);
                item.put('DIVISION',req.division);
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
                item.put('SALES_ORG',slsOrg);
            	item.put('DISTR_CHAN',defaultDistDiv);
            	item.put('DIVISION',defaultDistDiv);
                system.debug('else test-->1'+System.Label.Default_Distribution_Division);
                       }
            //Ps.PRICE_DATE = dt;
            if(!String.isEmpty(req.salesgrp))
            	item.put('SALES_GRP',req.salesgrp);
            else
                item.put('SALES_GRP',System.Label.Default_SalesOffice_SalesOrg);
        	//system.debug('--->1'+!String.isEmpty(availWrapper.salesoffice)+'def-->'+System.Label.Default_SalesOffice_SalesOrg);
            if(!String.isEmpty(req.salesoffice))
                item.put('SALES_OFF',req.salesoffice);
            else
                item.put('SALES_OFF',System.Label.Default_SalesOffice_SalesOrg);
            //item.put('companycode',req.companycode);
            // item.put('SALES_OFF',req.salesoffice);
            //item.put('SALES_GRP',req.salesgrp);
			item.put('PRICE_DATE',dt);
            item.put('REQ_DATE_H',dt);
            reqBody.Put('ORDER_HEADER_IN',item);
            items=new List<Object>();
            for(GetPrice_RequestFromCmp.productMaterial g : req.productMaterial)
            {
                system.debug('productmaterial--->'+g);
                item=new Map<String,String>();
                item.put('ITM_NUMBER',g.itemnumber);
                item.put('COND_TYPE','ZD01');
                item.put('COND_VALUE',String.valueOf(g.Discount));
                items.add(item);
      
            }
            mapObObj=new Map<String,Object>();
            mapObObj.put('item',items);
            reqBody.put('ORDER_CONDITIONS_IN',mapObObj);

            items=new List<Object>();
            for(GetPrice_RequestFromCmp.productMaterial g : req.productMaterial)
            {
                system.debug('productmaterial--->'+g);
                item=new Map<String,String>();
                item.put('ITM_NUMBER',g.itemnumber);
                item.put('MATERIAL',g.MaterialID);
                
                item.put('TARGET_QTY',String.valueOf(g.Quantity));
                items.add(item);
             }
			
			mapObObj=new Map<String,Object>();
            mapObObj.put('item',items);
            reqBody.put('ORDER_ITEMS_IN',mapObObj);
                        
           /* 
            
            
            item.put('ITM_NUMBER','000010');
            item.put('COND_TYPE','ZD01');
            item.put('COND_VALUE','7.5');
            items.add(item);
            item.put('ITM_NUMBER','000020');
            item.put('COND_TYPE','ZD01');
            item.put('COND_VALUE','10.0');
            items.add(item);
            mapObObj.put('item',items);
            //request.setHeader('ORDER_CONDITIONS_IN', JSON.serialize(mapObObj));
            reqBody.put('ORDER_CONDITIONS_IN',mapObObj);
            
            system.debug( JSON.serialize(mapObObj));
            mapObObj=new Map<String,Object>();
            item=new Map<String,String>();
            items=new List<Object>();
            
            
            
            item.put('ITM_NUMBER','000010');
            item.put('MATERIAL','10105010000');
            item.put('PLANT','1200');
            item.put('TARGET_QTY','1.000');
            items.add(item);
            item.put('ITM_NUMBER','000020');
            item.put('MATERIAL','10105020000');
            item.put('PLANT','1200');
            item.put('TARGET_QTY','1.000');
            items.add(item);
            mapObObj.put('item',items);
            //request.setHeader('ORDER_ITEMS_IN', JSON.serialize(mapObObj));
            reqBody.put('ORDER_ITEMS_IN',mapObObj);
            */
            mapObObj=new Map<String,Object>();
            item=new Map<String,String>();
            items=new List<Object>();
            item.put('PARTN_ROLE','AG');
            item.put('PARTN_NUMB','101474');
            
            items.add(item);
            item.put('PARTN_ROLE','WE');
            item.put('PARTN_NUMB','101474');
            item.put('ADDR_LINK','100');            
            items.add(item);
            mapObObj.put('item',items);
            
            //request.setHeader('ORDER_PARTNERS', JSON.serialize(mapObObj));
            reqBody.put('ORDER_PARTNERS',mapObObj);
            
            mapObObj=new Map<String,Object>();
            item=new Map<String,String>();
            items=new List<Object>();
            item.put('ADDR_NO','100');
            item.put('NAME','Hennie Nel');
            item.put('CITY','Phoenix');
            item.put('POSTL_COD1','85048');
            item.put('STREET','2635 E Amberwood Dr');
            item.put('COUNTRY','US');
            item.put('REGION','AZ');
            mapObObj.put('item',items);
            system.debug('--- request object'+reqBody);
            //request.setHeader('PARTNERADDRESSES', JSON.serialize(mapObObj));
            reqBody.put('PARTNERADDRESSES',mapObObj);
            
            String endpoint = 'https://ccdp1.yeti.com/RESTAdapter/CC_REST_SNDR_Pricing_Simulate/S4/PricingSimulate';
            //http://vhyetdp1ci.hec.yeti.com:50000/RESTAdapter/CC_REST_SNDR_Pricing_Simulate/S4/PricingSimulate
            request.setEndpoint(endpoint);
            request.setTimeout(120000);
            string encodedecred=EncodingUtil.base64Encode(blob.valueof('PI_COMM_USER:54iBhKx1^dsb'));
            request.setHeader('Content-Type','application/json');
            
            request.setHeader('Authorization', 'Basic '+encodedecred); 
            //request.setHeader('ORDER_HEADER_IN', OrderHeader); 
            //reqBody.put('ORDER_HEADER_IN',OrderHeader);
            request.setBody(JSON.serialize(reqBody));
            request.setMethod('POST');
            
            system.debug('@@@'+JSON.serialize(reqBody));
            HttpResponse response = http.send(request);
            
            //If request is successful, Parse thhe JSON response
            if(response.getStatusCode() == 200) {
                //Deserialize JSON string into the Collections of Primitive data types
                
                system.debug('Products Prices from SAP ==> ' +response.getBody());
                return response.getBody();
                
            }
            
            else{
                system.debug('STATUS:' +response.getStatus());
                system.debug('Body:' +response.getBody());
                
                return 'Error';
            }
            
        } catch(Exception ex){
            system.debug(ex);
            throw new AuraHandledException('Error Occurred: ' +ex.getMessage());
        }
    }

public static List<String> OrderUpda(JSONParser parser) {
	List<String> responseType = new List<string>();	
    while (parser.nextToken() != null) {
            system.debug('JSON Token-->'+parser.getText());
               
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != null) {
					if (text == 'MESSAGE') {
						system.debug('Type-->'+parser.getText());
                        responseType.add(parser.getText());
					} 
				}
			}
		}
    return responseType;
	}
}
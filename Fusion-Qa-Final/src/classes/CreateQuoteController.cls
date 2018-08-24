/**************************************************************************************************************************
Name: CreateQuoteController      
Description: Server Side Controller for the Create Quote Screen which commits the data to database. 

Date         Version          Author             Summary of Changes 
*****************************************************************************************************************************
07/24/2018    1.0        Ranjith Thadakala        Initial Release
***************************************************************************************************************************/
Public with sharing class CreateQuoteController {

   
    
   /* This Class to Capute the Input Fields From Quote Screen */ 
    Public with sharing class QuoteHeaderWrapper {
        public Date InHandsDate;
        public Date DoNotShipBefore;
        public Id accountID;
        public Id opportunityId;
        public Integer itemnumbertocature;
    }
    
    public class saporgDetails{
     public String salesOrg;
	public String distribution;
	public String division;
	public String companycode;
	public String salesoffice;
	public String salesgrp;

    }


  /* This Class to send Responce to Lightning component */
    
    Public with sharing class ResponseObject {

        @AuraEnabled public Id quoteId {
            get;
            set;
        }
        @AuraEnabled public List < Quote_Item_Level__c > Listupdated {
            get;
            set;
        }
        @AuraEnabled public List < Quote_Item_Level__c > newListupdated {
            get;
            set;
        }
        
         @AuraEnabled public string  jsnString {
            get;
            set;
        }
    }

/* This class to Capture the Line Item fields From Quote Screen */
    Public with sharing class LineItems {
        public String Id;
        public String Name;
        public String UPK;
        public String Description;
        public String ProductLocation;
        public String itemnumber;
        public Id headerid;
        public Id lineId;
        public Id QuoteItemId;
        public String category;
        public Decimal unitprice;
        public Decimal Quantity;
        public Decimal Tax;
        public Decimal Total;
        Public String MaterialID;
        public String measure;
        public String Discountmeasure;
        public Decimal Discount;
        public List<Jsondata> jsondata;
       
    }
    
   public class Jsondata {
		public String version;
		public String customtype;
		public String ramsideloc;
		public String productkey;
		public String ramvertloc;
		public String ramorientation;
		public String custpreview;
		public String warpedpreview;
		public String laserimage;
        public Id artid;
		public Prepared prepared;
	}
    public class Prepared {
		public String itemid;
		public String itemkeyid;
		public String itembasekey;
		public Boolean premium;
	}
    
    public class objectids{
        
        public Id QuoteId;
		public Id QuoteItemId;
		public List<Artwork__c> ArtIds;
        public string itemID;
        
    }
    
  

/* this method is to get the base price and availability */
    @AuraEnabled
    public static String getAvailability(String productsearchjson){
      
        return ProductServiceRequestApex.checkAvailability(productsearchjson);
        
    }
    
    
/* this method is to get the pricing from SAP */
    @AuraEnabled
    public static String getProductPricing(String productjson){
      
        return GetPrices_Quote.getModifiedStructurePrices(productjson);
        
    }
       
/* This method called In Quote Screen to Commits the Data to Database */    
    
    @AuraEnabled
    public static ResponseObject saveandupdateQuote(String QuoteDetails, String newList,  String QuoteId, String Status, string sapdetails) {
        system.debug(newList);
        system.debug(QuoteDetails);
        system.debug(QuoteId);
        system.debug(sapdetails);
         string usrCountry;
        string results;
        List < Quote_Item_Level__c > newobjlist = new List < Quote_Item_Level__c > ();
        List < Quote_Item_Level__c > updateobjlist = new List < Quote_Item_Level__c > ();
        
        ResponseObject resobj = new ResponseObject();
        
        QuoteHeaderWrapper quotedetailswrapper = (QuoteHeaderWrapper) JSON.deserialize(QuoteDetails, QuoteHeaderWrapper.class);
        saporgDetails saporgDetailswrapper = (saporgDetails) JSON.deserialize(sapdetails, saporgDetails.class);
        String s1 = newList.replace('UPK__c', 'UPK');
        String s2 = s1.replace('ProductLocation__c', 'ProductLocation');
        String s3 = s2.replace('category__c', 'category');
         String s4 = s3.replace('MaterialID__c', 'MaterialID');
        system.debug(s3);
        List < LineItems > newItemsWrapper;
       system.debug(saporgDetailswrapper);
        if (!s2.equals('null')) {
           // system.debug(!s2.equals('null'));
            newItemsWrapper = (List < LineItems > ) System.JSON.deserialize(s4, List < LineItems > .class);
        }



        if (!String.isEmpty(QuoteId)) {

            //system.debug(!String.isEmpty(QuoteId));
            Quote_Header__c QutObj = [select id, In_Hands_Date__c, Do_Not_Ship_Before__c from Quote_Header__c where id =: QuoteId limit 1];
            system.debug(QutObj);

            QutObj.In_Hands_Date__c = quotedetailswrapper.InHandsDate;
            QutObj.Do_Not_Ship_Before__c = quotedetailswrapper.DoNotShipBefore;
            QutObj.ItemNumberToCapture__c = quotedetailswrapper.itemnumbertocature;
            if (!String.isEmpty(Status))   QutObj.Status__c = Status;
             else   QutObj.Status__c = 'New'; 
            if(!String.isEmpty(saporgDetailswrapper.salesOrg)){
               QutObj.Sales_Organization__c =saporgDetailswrapper.salesOrg;
QutObj.Sales_Office__c=saporgDetailswrapper.salesoffice;
QutObj.Sales_Group__c=saporgDetailswrapper.salesgrp;
QutObj.Company_Code__c=saporgDetailswrapper.companycode;
QutObj.Division__c=saporgDetailswrapper.division;
QutObj.Distribution_Channel__c=saporgDetailswrapper.distribution;

            }else{
                usrCountry = [Select country From User Where Id = :UserInfo.getUserId()][0].country;
               system.debug('-->ctry'+usrCountry);
               if(usrCountry == null || usrCountry == '')
               {
                   usrCountry = 'US';
               }
               if(usrCountry == 'US')
                   usrCountry = usrCountry+'-'+System.Label.Default_Us_Sales_Org;
               

              

               QutObj.Sales_Organization__c = Country_SalesOrg_CompanyCode__c.getInstance(usrCountry).Sales_Org__C;
               QutObj.Company_Code__c = SalesOrg_CompanyCode__c.getInstance(Country_SalesOrg_CompanyCode__c.getInstance(usrCountry).Sales_Org__C).Company_Code__c;
               QutObj.Division__c = System.Label.Default_Distribution_Division;

QutObj.Distribution_Channel__c= System.Label.Default_Distribution_Division;

QutObj.Sales_Group__c=System.Label.Default_SalesOffice_SalesOrg;
QutObj.Sales_Office__c=System.Label.Default_SalesOffice_SalesOrg;


               
               
                      }
                
            
             update QutObj;
            resobj.quoteId = QutObj.Id;
           
           
            
           


            if (!s2.equals('null') && !newItemsWrapper.equals('null')) {

               // system.debug(!newItemsWrapper.isEmpty());
               // newobjlist = CreateQuoteController.insertNewList(newItemsWrapper, QutObj.Id);
                results =  CreateQuoteController.insertNewList(newItemsWrapper, QutObj.Id);
                resobj.jsnString = results;
            } else {
                resobj.newListupdated = null;
            }
       

        } else {
            
            Quote_Header__c QutObject = new Quote_Header__c();
            QutObject.Account__c = quotedetailswrapper.accountID;
            QutObject.Opportunity__c = quotedetailswrapper.opportunityId;
            QutObject.In_Hands_Date__c = quotedetailswrapper.InHandsDate;
            QutObject.Do_Not_Ship_Before__c = quotedetailswrapper.DoNotShipBefore;
            QutObject.ItemNumberToCapture__c = quotedetailswrapper.itemnumbertocature;
            QutObject.Status__c = 'New';
            if(!String.isEmpty(saporgDetailswrapper.salesOrg)){
               QutObject.Sales_Organization__c =saporgDetailswrapper.salesOrg;
QutObject.Sales_Office__c=saporgDetailswrapper.salesoffice;
QutObject.Sales_Group__c=saporgDetailswrapper.salesgrp;
QutObject.Company_Code__c=saporgDetailswrapper.companycode;
QutObject.Division__c=saporgDetailswrapper.division;
QutObject.Distribution_Channel__c=saporgDetailswrapper.distribution;

            }else{
                usrCountry = [Select country From User Where Id = :UserInfo.getUserId()][0].country;
               system.debug('-->ctry'+usrCountry);
               if(usrCountry == null || usrCountry == '')
               {
                   usrCountry = 'US';
               }
               if(usrCountry == 'US')
                   usrCountry = usrCountry+'-'+System.Label.Default_Us_Sales_Org;
               

              

               QutObject.Sales_Organization__c = Country_SalesOrg_CompanyCode__c.getInstance(usrCountry).Sales_Org__C;
               QutObject.Company_Code__c = SalesOrg_CompanyCode__c.getInstance(Country_SalesOrg_CompanyCode__c.getInstance(usrCountry).Sales_Org__C).Company_Code__c;
               QutObject.Division__c = System.Label.Default_Distribution_Division;

QutObject.Distribution_Channel__c= System.Label.Default_Distribution_Division;

QutObject.Sales_Group__c=System.Label.Default_SalesOffice_SalesOrg;
QutObject.Sales_Office__c=System.Label.Default_SalesOffice_SalesOrg;


               
               
                      }
            insert QutObject;

            resobj.quoteId = QutObject.Id;



           // system.debug(newItemsWrapper.size());
            
            if (newItemsWrapper.size() > 0) {

              //  newobjlist = CreateQuoteController.insertNewList(newItemsWrapper, QutObject.Id);
            results = CreateQuoteController.insertNewList(newItemsWrapper, QutObject.Id);
            resobj.jsnString = results;   
            }


        }
       // system.debug(updateobjlist);
       // system.debug(newobjlist);
        resobj.Listupdated = updateobjlist;
        if (!newobjlist.equals('null')) resobj.newListupdated = newobjlist;

        return resobj;
    }

/* This is a common method for inserting line Items */
    public static String insertNewList(List < LineItems > lineList, Id QuoteId) {
        
         system.debug(lineList);
        system.debug(QuoteId);
        
      
       list<Quote_Item_Level__c> supdateList = new list<Quote_Item_Level__c>();
       list<Artwork__c> AupdateList = new list<Artwork__c>();
        
       list<sObject> sobjectlist = new list<sObject>();
        
       list<sObject> QuoteItemList = new list<sObject>();
       list<sObject> Artworklist = new list<sObject>();
       string jsnstring ; 
for (LineItems lineObj : lineList) {
            
            Quote_Item_Level__c newquotlineObj = new Quote_Item_Level__c();
             string n = String.ValueOf(Integer.valueOf(math.rint(math.random()*1000000)));
            newquotlineObj.Quote_Header__c = QuoteId;
            newquotlineObj.Name = lineObj.Name;
            newquotlineObj.Product_Description__c = lineObj.Description;
            newquotlineObj.Quote_Item_Number__c = lineObj.itemnumber;
            newquotlineObj.ProductUrl__c =  lineObj.ProductLocation;
             newquotlineObj.Unit_Rate__c = lineObj.unitprice;
              newquotlineObj.Quantity__c = lineObj.Quantity;
                  newquotlineObj.Tax__c = lineObj.Tax;
                  newquotlineObj.Item__c = lineObj.Total;
             newquotlineObj.MaterialID__c = lineObj.MaterialID;
             newquotlineObj.Measure__c = lineObj.measure;
            newquotlineObj.Discountmeasure__c = lineObj.Discountmeasure;
         newquotlineObj.Discount_Item__c = lineObj.Discount;
           newquotlineObj.UPK__c= lineObj.UPK;
            system.debug(lineObj.ProductLocation);
            newquotlineObj.CategorySection__c = lineObj.category;
    system.debug(lineObj.QuoteItemId != null);
         if(lineObj.QuoteItemId != null) {
        newquotlineObj.Id = lineObj.QuoteItemId;
        supdateList.add(newquotlineObj);
        system.debug(supdateList);
       }else{
        newquotlineObj.ExternalId__c = n;
           QuoteItemList.add(newquotlineObj);
       } 
      
    system.debug('-->'+lineObj.jsondata);
            
       if(lineObj.jsondata != null ){
            system.debug('test');
         
             Quote_Item_Level__c refid = new Quote_Item_Level__c(ExternalId__c = n);  
            system.debug(n); 
           
           
            
            for( Jsondata jsnobj : lineObj.jsondata){
               
                Artwork__c artobj = new Artwork__c();
                artobj.Art_BMP_URL__c = jsnobj.laserimage;
                artobj.FlatImage__c = jsnobj.custpreview;
                artobj.UPK__c = jsnobj.productkey;
                //artobj.Art_JSON__c = String.ValueOf(artobj);
                artobj.ramsideloc__c =  jsnobj.ramsideloc; 
                artobj.Name = jsnobj.customtype;
                if(jsnobj.artid != null && lineObj.QuoteItemId != null){
                artobj.Id =  jsnobj.artid; 
                AupdateList.add(artobj);
                }
                else if(jsnobj.artid == null && lineObj.QuoteItemId != null){
                    artobj.Quote_Item__c = lineObj.QuoteItemId;
                    Artworklist.add(artobj);
                }else{
                   artobj.Quote_Item__r = refid;
                    Artworklist.add(artobj);
                }
               
                
                
            }
          }
    
        }
        
       
        if(QuoteItemList.size() > 0) sobjectlist.addAll(QuoteItemList);
        if(Artworklist.size() > 0) sobjectlist.addAll(Artworklist); 
         
        if(supdateList.size() > 0)  Database.SaveResult[] results1 = Database.update(supdateList);
        if(AupdateList.size() > 0)  Database.SaveResult[] results2 = Database.update(AupdateList);
       system.debug('test3');
        if(sobjectlist.size() > 0) Database.SaveResult[] results = Database.insert(sobjectlist);
          
            system.debug(JSON.serialize(sobjectlist));
            system.debug('hai');  
            List<Quote_Item_Level__c> lineitemlist = [select Id,Quote_Header__c,Quote_Item_Number__c,(select id,Name from Artworks__r ) from Quote_Item_Level__c where Quote_Header__c =: QuoteId ];
            
            List<objectids> idlist = new List<objectids>();
            for(Quote_Item_Level__c quoteitem : lineitemlist){
                objectids objid = new objectids();
                objid.QuoteId =quoteitem.Quote_Header__c; 
                objid.QuoteItemId = quoteitem.Id;
                objid.ArtIds = quoteitem.Artworks__r;
                objid.itemID = quoteitem.Quote_Item_Number__c;
              idlist.add(objid);  
            }
             jsnstring = JSON.serialize(idlist);
            
        
            
            
            return jsnstring ;
       /* } catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i));
            }
            return null;

        }*/


    }
    
    public class EditResponce{
        @AuraEnabled Public Quote_Header__c QuoteObj 	{get;set;}
        @AuraEnabled Public String lineList {get;set;}
        @AuraEnabled Public boolean Accessble {get;set;}
    }
    
     @AuraEnabled
    public static EditResponce getQuoteDetails(Id recId){
        Boolean Access;
        Quote_Header__c headerObj;
        EditResponce editObj = new EditResponce();
        system.debug(!Schema.sObjectType.Quote_Header__c.fields.ExpireQuote__c.isAccessible());
        if(Schema.sObjectType.Quote_Header__c.fields.Expires__c.isAccessible()){
          
            headerObj = [select Id, Account__c,Account__r.Name,In_Hands_Date__c,Expires__c,ItemNumberToCapture__c,Opportunity__c,Status__c,Do_Not_Ship_Before__c,(select Id,Name,Product_Description__c,ProductUrl__c From Quote_Items__r )From Quote_Header__c where 
                                    Id = : recId ];
            Access = false;
           editObj.QuoteObj = headerObj;
           editObj.Accessble = Access;
        }
        else{
             headerObj = [select Id, Account__c,In_Hands_Date__c,Account__r.Name,Expires__c,Opportunity__c,ItemNumberToCapture__c,Status__c,Do_Not_Ship_Before__c,(select Id,Name,Product_Description__c,ProductUrl__c From Quote_Items__r )From Quote_Header__c where 
                                    Id = : recId ]; 
             Access = True;
           editObj.QuoteObj = headerObj;
           editObj.Accessble = Access;
        }
      
         List<Quote_Item_Level__c> lineitems = QuoteTabController.getRelatedLineItems(recId);
        
       
        
         
        
        List<LineItems> linelist = new List<LineItems>(); 
         
         for(Quote_Item_Level__c quoteItem : lineitems){
            LineItems lineobj = new LineItems();
             lineobj.Name = quoteItem.Name;
             lineobj.Description=quoteItem.Product_Description__c;
             lineobj.ProductLocation = quoteItem.ProductUrl__c;
             lineobj.itemnumber = quoteItem.Quote_Item_Number__c;
             lineobj.QuoteItemId = quoteItem.Id;
             lineobj.category = quoteItem.CategorySection__c;
             lineobj.unitprice = quoteItem.Unit_Rate__c;
             lineobj.Quantity = quoteItem.Quantity__c;
             lineobj.Tax = quoteItem.Tax__c;
             lineobj.Total = quoteItem.Item__c;
             lineobj.MaterialID = quoteItem.MaterialID__c;
             lineobj.measure  = quoteItem.Measure__c; 
             lineobj.Discountmeasure = quoteItem.Discountmeasure__c;
             lineobj.Discount = quoteItem.Discount_Item__c;
             lineobj.UPK = quoteItem.UPK__c;
           List<Jsondata> jsondatalist = new List<Jsondata>(); 
           for( Artwork__c artobj : quoteItem.Artworks__r){
               Jsondata jsnobj = new Jsondata();
                jsnobj.customtype = artobj.Name;
                jsnobj.ramsideloc =artobj.ramsideloc__c;
                jsnobj.custpreview=artobj.FlatImage__c;
                jsnobj.laserimage=artobj.Art_BMP_URL__c;
               jsnobj.artid=artobj.Id;
             jsondatalist.add(jsnobj);    
           }
             lineobj.jsondata = jsondatalist;
             linelist.add(lineobj);
         }
        string s = JSON.serialize(linelist);
        String s1 = s.replace('UPK','UPK__c');
        String s2 = s1.replace('ProductLocation','ProductLocation__c');
        String s3 = s2.replace('category','category__c');
        String s4 = s3.replace('MaterialID','MaterialID__c');
        
       editObj.lineList = s4;
       return editObj;
    }

}
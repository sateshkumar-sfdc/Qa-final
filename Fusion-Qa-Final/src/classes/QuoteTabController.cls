public class QuoteTabController {
    
    @AuraEnabled
    public static List<Quote_Item_Level__c> getRelatedLineItems(Id QuoteId){
        List<Quote_Item_Level__c> lineitems = [select Id, Name,ProductUrl__c,UPK__c,Discountmeasure__c,Discount_Item__c, Product_Description__c,Quote_Item_Number__c,Unit_Rate__c,Tax__c,Measure__c,MaterialID__c,Quantity__c,Item__c,CategorySection__c,(Select Id,Name,FlatImage__c,Art_BMP_URL__c,ramsideloc__c from Artworks__r ) from Quote_Item_Level__c where Quote_Header__c =:QuoteId];
      //Quote_Header__c quoteObj = [select Id,(select Id, Name,ProductUrl__c, Product_Description__c from Quote_Items__r) from Quote_Header__c where Id =: QuoteId limit 1];
      //return quoteObj.Quote_Items__r;
      return lineitems;
    }

}
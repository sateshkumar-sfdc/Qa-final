public class QuoteViewHighlightPanelController {
    
    @AuraEnabled
    Public static string changeQuoteStatus(Id QuoteId){
        String message = QuoteCommonUtil.expireQuote(QuoteId);
        return message;
    }
    
    @AuraEnabled
   public static void margeCallout(string qutoeHeaderId)
   {
       List<account> aList = new List<Account>();
       Quote_Header__c qh = [select Account__c from Quote_Header__c where id =: qutoeHeaderId];
       Account a = [select id, name, Email__c, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry, SAPCustomerNumber__c, (select id, name, Email__c, Phone, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry,  SAPCustomerNumber__c from ChildAccounts where recordType.Name = 'Ship to') from account where id =: qh.Account__c];
       System.debug('Account info --------->'+a);
     //  System.debug('Account Ship to Request--->'+a.ChildAccounts[0]);
       if(a.ChildAccounts.size() > 0)
       {
           ShipToResponse shipRes = AccountSAPCallOut.shipToCallOut(a.ChildAccounts[0]);
           SoldToResponse soldRes = AccountSAPCallOut.soldToCallout(a);
           AccountSAPCallOut.soldShipCallout(shipRes.BUSINESSPARTNER, soldRes.BUSINESSPARTNER);
           a.SAPCustomerNumber__c =soldRes.BUSINESSPARTNER;
           a.ChildAccounts[0].SAPCustomerNumber__c = shipRes.BUSINESSPARTNER;
           System.debug('Response SHip To---->'+a.ChildAccounts[0].SAPCustomerNumber__c);
           aList.add(a);
           aList.add(a.ChildAccounts[0]);
       }
       else
       {
           SoldToResponse soldRes = AccountSAPCallOut.soldToCallout(a);
           a.SAPCustomerNumber__c =soldRes.BUSINESSPARTNER;
           System.debug('Response Sold To---->'+a.SAPCustomerNumber__c);
           alist.add(a);


       }

       update aList;

   }

}
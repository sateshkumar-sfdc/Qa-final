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
     
       if(a.ChildAccounts.size() > 0) 
       {
           if(a.ChildAccounts[0].SAPCustomerNumber__c == null || a.ChildAccounts[0].SAPCustomerNumber__c== ''){
                ShipToResponse shipRes = AccountSAPCallOut.shipToCallOut(a.ChildAccounts[0]);
               a.ChildAccounts[0].SAPCustomerNumber__c =shipRes.BUSINESSPARTNER;
           }
          
           if(a.SAPCustomerNumber__c == null || a.SAPCustomerNumber__c== ''){
           SoldToResponse soldRes = AccountSAPCallOut.soldToCallout(a);
           
            a.SAPCustomerNumber__c =soldRes.BUSINESSPARTNER;
           }
           AccountSAPCallOut.soldShipCallout(a.ChildAccounts[0].SAPCustomerNumber__c, a.SAPCustomerNumber__c);
           
           System.debug('Response SHip To---->'+a.ChildAccounts[0].SAPCustomerNumber__c);
           System.debug('Response Sold To---->'+a.SAPCustomerNumber__c);
           aList.add(a);
           aList.add(a.ChildAccounts[0]);
       }
       else
       {
           if(a.SAPCustomerNumber__c == null || a.SAPCustomerNumber__c== ''){
           SoldToResponse soldRes = AccountSAPCallOut.soldToCallout(a);
           a.SAPCustomerNumber__c =soldRes.BUSINESSPARTNER;
           }
           System.debug('Response Sold To---->'+a.SAPCustomerNumber__c);
           alist.add(a);


       }

       update aList;

   }

}
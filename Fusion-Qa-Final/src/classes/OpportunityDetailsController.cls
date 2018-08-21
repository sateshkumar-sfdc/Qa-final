public class OpportunityDetailsController {
    @AuraEnabled
    public static List<Opportunity> getRelatedOpportunities(Id recId){
         system.debug(recId);
         Account accobj = [Select Id,(select Id, Name,StageName,Type, CreatedDate from Opportunities where IsClosed = false ) from Account where Id =:recId limit 1];
         return accobj.Opportunities;
    }
     @AuraEnabled
     public static List<Contact> getRelatedContacts(Id AccId){
         Account Accobj = [Select Id,(select Id, Name,Phone,Email from Contacts) from Account where Id =:AccId limit 1];
         return Accobj.Contacts;
    }
    
    @AuraEnabled
    public static String  cloneQuote(Id QuoteID, String oppId, String ContactId, Id Accid ){
        
    try{   
     String header = '';
     String lineitems='';
     Id OpportunityId;
     Id conId;
     String CloneQuoteId = '';
        if(oppId != null && oppId != 'None'){
            OpportunityId = oppId;
        }else{
            Account acc = [select name from Account where Id =:Accid limit 1 ];
            Opportunity oppobj = new Opportunity();
            oppobj.AccountId = Accid;
            oppobj.Name = acc.Name+system.today();
            oppobj.CloseDate = system.today() + 30;
            oppobj.StageName = 'New';
            oppobj.PO_Number__c = '1234';
            oppobj.Need_By_Date__c = system.today();
            insert oppobj;
            OpportunityId = oppobj.Id;
        }
        system.debug(OpportunityId);
        if(ContactId != null && ContactId != 'None'){
            conId = ContactId;
            
        }else{
            system.debug(ContactId);
             Account acc = [select name from Account where Id =:Accid limit 1 ];
           Contact conobj = new Contact();
            conobj.AccountId = Accid;
            conobj.LastName = acc.Name;
            insert conobj;
           conId  =  conobj.Id;          
        }
        system.debug(conId);
        
   if(OpportunityId != null && conId != null ){  
     String sObjName = QuoteID.getSObjectType().getDescribe().getName();   
     List<String> quoteheaderfields = QuoteCommonUtil.getSobjectFields(sObjName);
        quoteheaderfields.remove(quoteheaderfields.indexOf('OwnerId'));
        quoteheaderfields.remove(quoteheaderfields.indexOf('ExpireQuote__c'));
      system.debug(quoteheaderfields);   
        
        
     List<String> quotelineitems = QuoteCommonUtil.getSobjectFields('Quote_Item_Level__c');
        quotelineitems.remove(quotelineitems.indexOf('OwnerId'));
        system.debug(quotelineitems);
        if (!quoteheaderfields.isEmpty()){
            for (string s:quoteheaderfields){
                header += s + ',';
            }
        }
        if (!quotelineitems.isEmpty()){
            for (string s1:quotelineitems){
                lineitems += s1 + ',';
            }
        }
        
        if (lineitems.endsWith(',')){lineitems = lineitems.substring(0,lineitems.lastIndexOf(','));}
        
        system.debug(header);
        system.debug(lineitems);
       String query = 'Select Id,' + header +'('+ 'Select'+ ' '+ lineitems +' '+'From Quote_Items__r ) From Quote_Header__c ' + 'where Id = : QuoteID';
       Quote_Header__c obj = Database.query(query);
        system.debug(obj);
        system.debug(obj.Quote_Items__r);
       Quote_Header__c obj2 = obj.clone(false, true);
        obj2.Status__c = 'New';
        obj2.Opportunity__c = OpportunityId;
        obj2.Contact__c = conId;
       insert obj2;
       CloneQuoteId = obj2.Id;
       List<Quote_Item_Level__c> listoj = new List<Quote_Item_Level__c>();
       for(Quote_Item_Level__c obj4 : obj.Quote_Items__r ){
        Quote_Item_Level__c onj3 = obj4.clone(false, true);
         onj3.Quote_Header__c = obj2.Id;
         listoj.add(onj3);
        }
       insert listoj;
      }else{
       system.debug('some error');
       }
       
     return CloneQuoteId;
     }catch(Exception e ){
            System.debug(e.getMessage());
         return null;
        }
 }

}
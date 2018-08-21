public class CreateQuote {
     @AuraEnabled
    public static List<Account> checkAccount(ID recId){
         String leadName;
         String CompanyName;
        List<Account> accList = new List<Account>();
        List<Lead> leadList = [SELECT Name, Company, email FROM lead WHERE id= :recId];
        if(leadList != null && leadList.size() > 0){
            leadName=leadList[0].Name; 
            CompanyName = leadList[0].Company;
        }
        leadName = '%' + leadName + '%';
        CompanyName = '%' + CompanyName + '%';
        accList =  [SELECT id, name, Owner.Name, phone FROM account WHERE Email__c =: leadList[0].email OR name Like: leadName or name Like: CompanyName LIMIT 1000]; 
        System.debug(accList);
        return accList;
    }
    
    @AuraEnabled
    public static List<Contact> checkContact(ID accId){
        account a = [select id, ParentId, (select id from ChildAccounts)from account where id =: accId];
        List<id> idList = new List<id>();
        idList.add(accId);
        if(a.ParentId != null)
        {
            idList.add(a.ParentId);
        }
        for(account ca : a.ChildAccounts)
        {
            idList.add(ca.id);
        }
        List<contact> conList = new List<contact>();
        conList = [select id, firstName, lastName, Phone, email from contact where accountId in: idList];
        return conList;
    }
    
    @AuraEnabled
    public static Id convertLead(ID recId, string accId, string conId)
    {
        List<id> idList = new List<id>();
        lead l = [select name,CurrencyIsoCode, (select id,Products__c,CurrencyIsoCode, Qty__c from ProductOfIntrests__r) from lead where id =: recId];
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(recId);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus('Converted');
        lc.setOwnerId(userinfo.getUserId());

        if(accId != '')
        {
            lc.setAccountId(accId);
        }
        
        if(conId != '')
        {
           lc.setContactId(conId);
        }
       
        Database.LeadConvertResult lcr = Database.convertLead(lc);
       
        idList.add(lcr.getAccountId());
        idList.add(lcr.getContactId());
        idList.add(lcr.getOpportunityId());
         System.debug('opportunity'+idList[2]);
        
        Quote_Header__c qh =  new Quote_Header__c(CurrencyIsoCode = l.CurrencyIsoCode, Account__c = idList[0], Contact__c = idList[1], Opportunity__c = idList[2], status__c = 'new');
        insert qh;
        idList.add(qh.id);

        Set<string> ProductNameList = new set<string>();
        
        for(ProductOfIntrest__c pi : l.ProductOfIntrests__r)
        {
           ProductNameList.add(pi.Products__c);
        }
        
        List<Product2> ProductList = [select id,name,ProductCode,Description,ProductLocation__c, MaterialID__c,category__c from Product2 where name in: ProductNameList];
		
        Map<string, Product2> proddMap = new Map<string, Product2>();
        for(Product2 p : ProductList){
            proddMap.put(p.name, p);
            
        }
        
        List<Quote_Item_Level__c> qiList =  new List<Quote_Item_Level__c>();
        	Integer lineItemNumber = 0;
        for(ProductOfIntrest__c pi : l.ProductOfIntrests__r)
        {
            lineItemNumber += 10;
            qiList.add( new Quote_Item_Level__c(
                								CurrencyIsoCode = pi.CurrencyIsoCode, 
                								Name = pi.Products__c,
                								Product_Code__c = proddMap.containsKey(pi.Products__c)? proddMap.get(pi.Products__c).ProductCode : '', 
                								Product_Description__c = proddMap.containsKey(pi.Products__c)? proddMap.get(pi.Products__c).Description : '',
                								ProductUrl__c = proddMap.containsKey(pi.Products__c)?proddMap.get(pi.Products__c).ProductLocation__c : '',
                								CategorySection__c = proddMap.containsKey(pi.Products__c)?proddMap.get(pi.Products__c).category__c : '',
                                                MaterialID__c = proddMap.containsKey(pi.Products__c)?proddMap.get(pi.Products__c).MaterialID__c : '',
                								Quantity__c = pi.Qty__c,Quote_Item_Number__c = String.valueOf(lineItemNumber),	
                								Quote_Header__c = qh.id));
        }
        
        if(qiList.size() > 0)
        {
            //system.debug('-- item number-->'+qiList[0].Quote_Item_Number__c+'--'+qiList[1].Quote_Item_Number__c);
            insert qiList;
        }
        system.debug('idList ' + idList);
        qh.ItemNumberToCapture__c = lineItemNumber;
        
        update qh;
        system.debug('qh--- ' + qh);
        return qh.id;
    }

}
/*
*************************************************************
** Name: AccountToQuote.apxc                               **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose:                  							   **
** Account To Quote, Contacts and Opportunity              **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 08/17/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/

public class AccountToQuote {
    
    
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
    public static List<Opportunity> checkOpportunity(ID accId){
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [select id, Name, StageName, CloseDate from Opportunity where accountId =: accId and (StageName != 'Closed Won' OR StageName != 'Closed Lost')];
        return oppList;
    }
    
    @AuraEnabled
    public static List<id> createRecords(ID accId, string conId, string oppId)
    {
        Account a = [select id, name,CurrencyIsoCode from account where id =: accId];
        List<id> idList = new List<id>();
        idList.add(a.id);
        
        if(conId == '')
        {
            List<string> name = a.Name.split(' ');
            contact c = new contact(accountId = a.id);
            if(name.size() == 2)
            {
                c.FirstName = Name[0];
                c.LastName = Name[1];
            }else
            {
                c.LastName = Name[0];
            }
            insert c;
            idList.add(c.id);
        }
        else{
            idList.add(conid);
        }
        
        if(oppId == '')
        {
            opportunity o = new opportunity(Name = a.Name, closeDate = Date.today(), StageName = 'Prospecting', accountId = a.id, CurrencyIsoCode = a.CurrencyIsoCode);
        	insert o;
            idList.add(o.id);
        }
        else{
            idList.add(oppId);
        }
        
        Quote_Header__c qh =  new Quote_Header__c(CurrencyIsoCode = a.CurrencyIsoCode, Account__c = idList[0], Contact__c = idList[1], Opportunity__c = idList[2], status__c = 'new', Expires__c = System.Today()+30);
        insert qh;
        idList.add(qh.id);
        
        return idList;
    }
}
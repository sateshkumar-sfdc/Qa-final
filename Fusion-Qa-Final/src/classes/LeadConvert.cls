/*
*************************************************************
** Name: LeadConvert.apxc                        	       **
** Copyright notice: 									   **
** YETI Coolers										       **
*************************************************************
** Purpose:                  							   **
** Lead Convert to Account, Contacts and Opportunity       **
*************************************************************
** History:                                                **
************************************************************* 
** VERSION AUTHOR DATE DETAIL RELEASE/CSR                  **
** 1.0 - Satesh Makineni 08/17/2018 INITIAL DEVELOPMENT    **
** 2.0 -                                                   **
*************************************************************
*/

public class LeadConvert {
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
    public static List<id> convertLead(ID recId, string accId, string conId)
    {
        List<id> idList = new List<id>();
        // lead l = [select name,CurrencyIsoCode, (select id,Products__c,CurrencyIsoCode from ProductOfIntrests__r) from lead where id =: recId];
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
        idList.add(lc.getOpportunityId());
        
      
        system.debug('idList ' + idList);
        return idList;
    }
    
}
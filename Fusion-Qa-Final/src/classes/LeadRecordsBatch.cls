global class LeadRecordsBatch implements Database.Batchable<sObject>,Database.Stateful{
    global List<String> exception_List = new List<String>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        string status1 ='Converted';
        string status2 = 'Expired';
        string status3 = 'Account Open';
        //string status2 = 'Not Qualified'; AND Status !=:status2
        string query = 'SELECT ID, Name, Status,First_Activity_Date__c,Date_of_Event__c,Rating,Total_Quantity__c,createdDate,RecordType.Name,Qualified__c From Lead WHERE Status !=:status1 AND Status !=:status2 AND Status !=:status3';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        list<Lead_BatchApex_RecordTypes__c> lst = Lead_BatchApex_RecordTypes__c.getall().values();
        set<string> recordtypeset = new set<string>();
        //set<string> recordtypeset = new set<string>{'BizDev', 'Fundraising', 'Outfitters'};
        for(Lead_BatchApex_RecordTypes__c leadRecTypes : lst)
        {
            system.debug('lead recs--->'+leadRecTypes.RecordType_Name__c);
            recordtypeset.add(leadRecTypes.RecordType_Name__c);
        }
        Set<Lead> leadsToUpdate = new Set<Lead>();
        List<Lead> leadsToUpdateList = new List<Lead>();
        for(sobject s : scope){
            Lead ld = (Lead)s;
            if(recordtypeset.contains(ld.RecordType.Name) && ld.First_Activity_Date__c!= null && (ld.Status == 'Not contacted' && ld.Qualified__c == false))
            {
                Date latestActivityDate = ld.First_Activity_Date__c.Date();
                date start = system.today();
                Integer ageFromLastActivity = latestActivityDate.daysBetween(start);
                if(ageFromLastActivity>=30)
                {
                    //ld.Disqualification_Reason__c = ld.Disqualification_Reason__c +' Lead Expired';
                    ld.Status = 'Expired';
                    leadsToUpdate.add(ld);
                }
                system.debug('ageFromLastActivity---------------------------------->'+ageFromLastActivity);
            }
            system.debug('current lead status---------------------------------->'+ld.Status);
            if(ld.Status != 'Expired')
            {	
                system.debug('test for if condition');
                //DateTime dT = system.today();
                //Date eventDate = date.newinstance(dT.year(), dT.month(), dT.day());
                Date createdDate = ld.createdDate.Date();
                system.debug('Date--->'+ld.createdDate);
                date start = system.today();
                date dueDate = ld.Date_of_Event__c;
                integer numberOfdays;
                if(ld.Date_of_Event__c!= Null)
                    numberOfdays = start.daysBetween(dueDate);
                Integer leadAge = createdDate.daysBetween(start);
                System.debug('Number of Days created,: '+numberOfdays+'-->'+ld.Date_of_Event__c);
                if(ld.Total_Quantity__c>=120 || (numberOfdays!= NULL && numberOfdays>0 && numberOfdays< 30 ) || (leadAge >30 && ld.Status == 'Not Contacted'))
                {
                    ld.Rating = 'High';
                    
                    system.debug('list rating--'+ld.Rating);
            	}
                else
                {
                    ld.Rating = 'Low';
                }
                leadsToUpdate.add(ld);
                }  
                
            }
        system.debug('list size--'+leadsToUpdate.size());
        if(leadsToUpdate.size()>0)
        {
            leadsToUpdateList.addAll(leadsToUpdate);
            system.debug('list up--'+leadsToUpdateList.size());
            Database.SaveResult[] SaveResultList = database.update(leadsToUpdateList,false);  
            Integer recordid = 0;
            for (Database.SaveResult SR : SaveResultList) {
                String message ='';
                if (!SR.isSuccess()) {
                    message += 'Lead Record:' + leadsToUpdateList[recordid].id + ', ' + SR.getErrors()[0].getMessage() + '<br/>';
                }
                if(message !='')
                    exception_List.add(message);
                recordid++;
            }
            system.debug('9999---->'+exception_List);
        }
    }
    global void finish(Database.BatchableContext BC){
        List<User> userList = new List<User>();
        userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ;
        List<string> toAddresses = new List<String>();
        String body = '';
        for(User u : userList)
        {           
            toAddresses.add(u.Email);
        }     
        if(exception_List.size()>0)
        {
            for(String s:exception_List)
            {
                body += '\n' +s;
            }
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);mail.setReplyTo('yetiadmin@yeticoolers.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed \n'+body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
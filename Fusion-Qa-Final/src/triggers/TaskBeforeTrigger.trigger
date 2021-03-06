trigger TaskBeforeTrigger on Task (before insert) {
    set<Id> setAccountIds = new set<Id>();
    for(Task t : trigger.New){
       if(!String.isBlank(t.whatID)){
            if(string.valueOf(t.WhatId).startsWith('001')){
                setAccountIds.add(t.whatId);
            }
        }
    }
        
    map<Id,Account> mapAccount = new map<Id,Account>([select Id,ENSX_EDM__SAP_Customer_Number__c from Account where Id IN: setAccountIds]);
    for(Task t : trigger.New){
        if(!String.isBlank(t.whatId)){
            if(string.valueOf(t.WhatId).startsWith('001') && mapAccount.containsKey(t.WhatId)){
                t.Sap_Customer_Number__c = mapAccount.get(t.WhatId).ENSX_EDM__SAP_Customer_Number__c;
            }
        }
    }
    }
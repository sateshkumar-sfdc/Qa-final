global class CreateEmailLead implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
        
        // Creating an InboundEmailResult object for returning the result of the  
        // Apex Email Service 
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String myPlainText= '';
        
        Set<String> allAddresses = new Set<String>();
        allAddresses.add(email.fromAddress);
        if(email.toAddresses!=null && email.toAddresses.size()>0)
            allAddresses.addAll(email.toAddresses);
        if(email.ccAddresses!=null && email.ccAddresses.size()>0)
            allAddresses.addAll(email.ccAddresses);
        
        system.debug('allAddresses => '+allAddresses);
        
        Map<String,Lead> existingAddresses = new Map<String,Lead>();
        List<Lead> leads = [SELECT Id, Name, Email, Description, OwnerId
                            FROM Lead
                            WHERE Email IN :allAddresses];
        
        for(Lead ld : leads){
            existingAddresses.put(ld.Email,ld);
        }
        
        List<Lead> newLeads = new List<Lead>();
        List<Task> newTasks = new List<Task>();
        for(String addr : allAddresses){
            if(addr.length()<=80){
                String emailDesc = 'MAIL DATE & TIME: '+Datetime.now().format()+
                    '\nSubject: '+email.subject+
                    '\nBody: '+email.plainTextBody;
                if(existingAddresses.containsKey(addr)){
                    String descr = existingAddresses.get(addr).Description + '\n\n ---NEW INCOMING MAIL--- \n' + emailDesc;
                    if(descr.length()<32000){
                        existingAddresses.get(addr).Description = descr;
                        
                        Task tk = new Task(
                            WhoId = existingAddresses.get(addr).Id,
                            OwnerId = existingAddresses.get(addr).OwnerId,
                            TaskSubtype = 'Email', 
                            Type = 'Email', 
                            Status = 'Completed',
                            Subject = 'Incoming-Email: '+email.subject,
                            Description = emailDesc,
                            ActivityDate = Date.today()
                        );
                        
                        newTasks.add(tk);
                    }
                }
                else{
                    Lead newLead = new Lead(Email = addr, 
                                            FirstName = '',                      
                                            LastName = addr.split('@')[0], 
                                            Email_Subject__c = email.subject,
                                            Description = emailDesc,
                                            Company = addr.split('@')[1].split('.co')[0]);
                    newLeads.add(newLead);
                }
            }
        }
                /*
        // Add the email plain text into the local variable  
        myPlainText = email.plainTextBody;
        
        // Check for existing leads with this email address   
        Lead[] leads = [SELECT Id, Name, Email
        FROM Lead
        WHERE Email = :email.fromAddress];
        
        if (leads.size() == 0) {
        // New Lead object to be created - set LastName and Company to
        // dummy values for simplicity
        Lead newLead = new Lead(Email = email.fromAddress, 
        FirstName = 'Chandra',                      
        LastName = 'Varkole', 
        Description = 'chandrayeti35@gmail.com',
        Company = 'Woopdedoo');
        
        // Insert a new lead
        insert newLead;    
        
        System.debug('New Lead record: ' + newLead );  
        
        } else {
        System.debug('Incoming email duplicates existing Lead record(s): ' + leads );    
        }
        */
        
        system.debug('existingAddresses => '+existingAddresses);
        system.debug('newLeads => '+newLeads);
        
        if(newLeads.size()>0){
            insert newLeads;
        }
        
        if(existingAddresses.values().size()>0){
            update existingAddresses.values();
        }
        
        for(Lead ld : newLeads){
            Task tk = new Task(
                WhoId = ld.Id,
                OwnerId = UserInfo.getUserId(),
                TaskSubtype = 'Email', 
                Type = 'Email', 
                Status = 'Completed',
                Subject = 'Incoming-Email: '+ld.Email_Subject__c,
                Description = ld.Description,
                ActivityDate = Date.today()
            );
            
            newTasks.add(tk);
        }
        
        system.debug('newTasks => '+newTasks);
        
        if(newTasks.size()>0){
            insert newTasks;
        }
        
        // Set the result to true. No need to send an email back to the user      
        // with an error message   
        result.success = true;
        
        // Return the result for the Apex Email Service 
        return result;
    }
}
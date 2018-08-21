@isTest(seeAllData=false)
public class CreateEmailLead_Test {
    @testSetup
    public static void createTestData(){
        Lead existingLead = new Lead(Email = 'test@xyz.com', 
                                     FirstName = 'TestFirstName',                      
                                     LastName = 'TestLastname', 
                                     Email_Subject__c = 'Test Email',
                                     Description = 'Test Email',
                                     Company = 'xyz');
        insert existingLead;
        Task tk = new Task(
                            WhoId = existingLead.Id,                            
                            TaskSubtype = 'Email', 
                            Type = 'Email', 
                            Status = 'Completed',
                            Subject = existingLead.Email_Subject__c,
                            Description = existingLead.Description,
                            ActivityDate = Date.today()
                        );
        insert tk;
    }
    public testmethod static void  newLeadTest(){
        list<lead>lstLead=[select id,Description from lead where Email='user2@acme.com'];
        system.assertEquals(0, lstLead.size());
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
        
        email.subject = 'test';
        email.toAddresses=new list<string>{'user@acme.com'};  
            email.ccAddresses=new list<string>{'user3@acme.com'};              
        email.fromAddress='user2@acme.com';
        email.plainTextBody='text Body';
        // set the body of the attachment
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'my attachment name';
        inAtt.mimeTypeSubType = 'plain/txt';        
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt }; 
        CreateEmailLead emailServiceObj = new CreateEmailLead();
        Messaging.InboundEmailResult serviceResult=emailServiceObj.handleInboundEmail(email, env );  
        system.assert(serviceResult.success=true);
        lstLead=[select id,(select id from tasks) from lead where Email='user2@acme.com'];
        system.assertEquals(1, lstLead.size());
        system.assert(lstLead[0].tasks.size()!=0);
    }
    public testmethod static void existingLeadTest(){
        list<lead>lstLead=[select id,Description,(select id from tasks) from lead where Email='test@xyz.com'];
        system.assertEquals(1, lstLead.size());
        system.assertEquals(1, lstLead[0].tasks.size());
        lead leadTeamp=lstLead[0];
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inAtt = new Messaging.InboundEmail.BinaryAttachment();
        
        email.subject = 'New Test Subject'; 
        email.plainTextBody='New text Body';
        //Email from existing lead's email id
        email.fromAddress='test@xyz.com';
        inAtt.body = blob.valueOf('test');
        inAtt.fileName = 'My attachment name';
        inAtt.mimeTypeSubType = 'plain/txt';        
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {inAtt}; 
        CreateEmailLead emailServiceObj = new CreateEmailLead();
        Messaging.InboundEmailResult serviceResult =emailServiceObj.handleInboundEmail(email, env );         
        system.assert(serviceResult.success=true);
        // check if new task is created or not
        lstLead=[select id,Description,(select id from tasks) from lead where Email='test@xyz.com'];
        system.assertEquals(1, lstLead.size());
        system.assertEquals(2, lstLead[0].tasks.size());
        //to check if description updated or not
        system.assert(leadTeamp.Description!=lstLead[0].Description);
        
    }
}
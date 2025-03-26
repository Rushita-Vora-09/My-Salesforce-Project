@isTest
private class SendEmailUsingGmailIntegrationApiTest {
    
    @IsTest
    public static void sendEmailTest() { 

        Test.startTest();
            SendEmailUsingGmailIntegrationApiApex.sendEmail('Test Subject', 'Test Body' ,'test@gmail.com');
            SendEmailUsingGmailIntegrationApiApex.sendEmail('Test Subject', 'Test Body' ,null);
            SendEmailUsingGmailIntegrationApiApex.sendEmail('Test Subject', 'Test Body' ,'test');
        Test.stopTest();
    }
}
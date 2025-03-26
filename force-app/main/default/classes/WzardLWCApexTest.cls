@isTest
private class WzardLWCApexTest {
    @IsTest
    public static void testAllApexContext() { 
        Test.startTest();
        WzardLWCApex.getAllRecords('Account');
        WzardLWCApex.getAllRecords('Contact');
        WzardLWCApex.getAllRecords('Opportunity');
        Test.stopTest();
    }        

    @IsTest
    public static void sendEmailTest() { 
        Test.startTest();
        WzardLWCApex.sendEmail('Test Subject', 'Test Body',new List<String>{'test@gmail.com'});
        WzardLWCApex.sendEmail('Test Subject', 'Test Body',new List<String>{});
        WzardLWCApex.sendEmail('Test Subject', 'Test Body',new List<String>{null});
        Test.stopTest();
    }
}
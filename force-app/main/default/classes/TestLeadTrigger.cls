@isTest
private class TestLeadTrigger {
    @isTest
    public static void testLeadTrigger() {
        List<Lead> leads = new List<Lead>{new Lead(FirstName = 'Test', LastName = 'Lead', Status = 'Open', Company = 'Test Company'), 
            new Lead(FirstName = 'Test2', LastName = 'Lead2', Company = 'Test Company2')};
        Test.startTest();
        insert leads;
        Test.stopTest();

        List<Lead> lead = [SELECT Id, LastName, Rating FROM Lead WHERE Id IN: leads AND Rating = 'Hot' WITH SECURITY_ENFORCED];
        System.assertEquals(2, lead.size(), 'No Leads found !');
    }
}
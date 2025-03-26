@isTest
private class AccountWrapperControllerAuraTest {
    @isTest 

    public static void accountWrapperControllerAuraTest() {
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
        insert con;
        Opportunity opp = new Opportunity(Name = 'Test Opp', StageName = 'Prospecting', CloseDate = Date.newInstance(2022, 04, 20), AccountId = acc.Id);
        insert opp;

        Test.startTest();
        AccountWrapperControllerAura.getAccConOpp();
        Test.stopTest();
    }
}
@isTest
private class AccountOpportunityControllerTest {
    @isTest
    static void testAccountOpportunityController() {
        // Create test Accounts
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{ acc1, acc2 };
        
        // Create test Opportunities
        Opportunity opp1 = new Opportunity(Name = 'Test Opportunity 1', AccountId = acc1.Id, StageName = 'Prospecting', Amount = 1000, CloseDate = Date.today());
        Opportunity opp2 = new Opportunity(Name = 'Test Opportunity 2', AccountId = acc1.Id, StageName = 'Closed Won', Amount = 2000, CloseDate = Date.today().addDays(10));
        insert new List<Opportunity>{ opp1, opp2 };
        
        // Instantiate controller
        Test.startTest();
        AccountOpportunityController controller = new AccountOpportunityController();
        Test.stopTest();
        
        // Validate account fetching
        System.assert(controller.pagedAccounts.size() > 0, 'Accounts should be fetched');
        
        // Select an account and fetch opportunities
        controller.selectedAccountId = acc1.Id;
        controller.fetchOpportunities();
        
        System.assert(controller.opportunities.size() > 0, 'Opportunities should be fetched for selected account');
        System.assertEquals('Mr.'+acc1.Name, controller.selectedAccountName, 'Selected account name should be correct');
        
        // Test pagination methods
        controller.nextAccountPage();
        controller.prevAccountPage();
        controller.nextOpportunityPage();
        controller.prevOpportunityPage();
        
        // Test backToAccounts method
        controller.backToAccounts();
        System.assert(controller.showAccountList, 'Account list should be displayed again');
        System.assertEquals(null, controller.selectedAccountId, 'Selected account ID should be reset');
    }
}
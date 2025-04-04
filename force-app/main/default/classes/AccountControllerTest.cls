@isTest
private class AccountControllerTest {
    @isTest
    static void testGetAllActiveAccounts() {
        // Create test Accounts
        Account activeAcc1 = new Account(Name = 'Active Account 1', Active__c = 'Yes');
        Account activeAcc2 = new Account(Name = 'Active Account 2', Active__c = 'Yes');
        Account inactiveAcc = new Account(Name = 'Inactive Account', Active__c = 'No');
        
        insert new List<Account>{ activeAcc1, activeAcc2, inactiveAcc };
        
        // Call the method
        Test.startTest();
        List<Account> result = AccountController.getAllActiveAccounts();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(2, result.size(), 'Only active accounts should be returned');
        Set<Id> expectedIds = new Set<Id>{ activeAcc1.Id, activeAcc2.Id };
        for (Account acc : result) {
            System.assert(expectedIds.contains(acc.Id), 'Returned account should be active');
        }
    }
}
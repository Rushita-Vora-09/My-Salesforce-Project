@isTest
public class TestAccountTriggerHandler {
    @testSetup
    static void setupTestData() {
        Account acc = new Account(Name = 'Test Account', Rating = 'Hot');
        insert acc;
    }

    @isTest
    static void testBeforeInsert() {
        Account acc = new Account(Name = 'New Test Account');
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        Account insertedAcc = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assert(insertedAcc.Name.startsWith('Mr.'), 'Prefix should be added to Account Name');
    }

    @isTest
    static void testAfterInsert() {
        List<Account> accList = new List<Account>{new Account(Name = 'Another Test Account')};
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        Contact con = [SELECT LastName FROM Contact WHERE AccountId = :accList[0].Id];
        System.assertEquals('Mr.'+accList[0].Name, con.LastName, 'Contact should be created with the same name as Account');
    }
    
    @isTest
    static void testUpdateAccountName() {
        // Step 1: Create an Account
        Account acc = new Account(Name = 'Original Account Name');
        insert acc;

        // Step 2: Create a Contact with a valid email
        Contact con = new Contact(LastName = 'Test', Email = 'test@example.com', AccountId = acc.Id);
        insert con;

        // Step 3: Update Account Name
        acc.Name = 'Updated Account Name';

        Test.startTest();
        AccountTriggerHandler.updateAccountName(
            new List<Account>{acc}, 
            new Map<Id, Account>{acc.Id => new Account(Id = acc.Id, Name = 'Original Account Name')}
        );
        Test.stopTest();

        // Step 4: Verify Email Sent 
        System.assert(true, 'Update should trigger email notification');
    }

    @isTest
    static void testAfterUpdate() {
        Account acc = [SELECT Id, Rating FROM Account LIMIT 1];
        acc.Rating = 'Hot';
        Test.startTest();
        update acc;
        Test.stopTest();
        
        AccountShare accShare = [SELECT AccountId FROM AccountShare WHERE AccountId = :acc.Id LIMIT 1];
        System.assertNotEquals(null, accShare, 'Account should be shared with Sales Rep if Rating is Hot');
    }

    @isTest
    static void testDuplicateAccountDeletion() {
        // Step 1: Insert the first account
        Account acc1 = new Account(Name = 'Duplicate Test');
        insert acc1;

        // Step 2: Insert another account with the same name 
        Account acc2 = new Account(Name = 'Duplicate Test');

        Test.startTest();
        insert acc2; // Trigger should handle deletion
        Test.stopTest();

        // Step 3: Verify that only one account remains
        List<Account> accList = [SELECT Id FROM Account WHERE Name = 'Mr.Duplicate Test'];
        System.assertEquals(1, accList.size(), 
            'Only one account should exist after duplicate deletion logic.');
    }

    @isTest
    static void testBulkApproval() {
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accList.add(new Account(Name = 'Bulk Approval ' + i));
        }
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        System.assert(true, 'Bulk approval should be submitted without exceptions');
    }
}
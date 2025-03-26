@isTest
private class TestForContactTrigger {

    // REMINDER : This test class is conflict with testUpdateMaxAmount
    @isTest
    public static void testDeleteRelatedAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
        insert con;
        Test.startTest();
        delete con;
        Test.stopTest();
        System.assertEquals(0, [SELECT Id FROM Account WHERE Id = :acc.Id WITH SECURITY_ENFORCED].size(), 'Account should be deleted'); 
    }

    @isTest 
    public static void testCreateContactRelatedEvent() {
        Contact con = new Contact(LastName = 'Test Contact');
        Test.startTest();
        insert con;
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM Event WHERE WhoId = :con.Id WITH SECURITY_ENFORCED], 'Event should be created');
    }

    @isTest 
    public static void testRollupSummaryOfContactsInsert() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<Contact> conList = new List<Contact>{  new Contact(LastName = 'Test Contact 1', AccountId = acc.Id, Amount__c = 100),
                                                    new Contact(LastName = 'Test Contact 2', AccountId = acc.Id, Amount__c = 200)};
        Test.startTest();
        insert conList;

        List<Contact> conUpdateList = new List<Contact>{ new Contact(Id = conList[1].Id, Amount__c = 300)};
        update conUpdateList;
        Test.stopTest();
        List<Account> accList = [SELECT Id, Total_Amount_Contact__c FROM Account WHERE Id = :acc.Id AND Total_Amount_Contact__c = 400 WITH SECURITY_ENFORCED];
        System.assertEquals(1, accList.size(), 'Total_Amount_Contact__c should be 400');
    }
    @isTest 
    public static void testUpdateTotalAmount(){
        Account acc = new Account(Name = 'Test Account 1');
        insert acc;
        Account acc2 = new Account(Name = 'Test Account 2');
        insert acc2;
        List<Contact> conList = new List<Contact>{  new Contact(LastName = 'Test Contact 1', AccountId = acc.Id),
                                                    new Contact(LastName = 'Test Contact 2', AccountId = acc.Id)};
        insert conList;
        Test.startTest();
        Contact conUpdate = new Contact(Id = conList[1].Id, AccountId = acc2.Id);
        update conUpdate;
        Test.stopTest();

        List<Contact> updatedConList = [SELECT Id FROM Contact WHERE Id = :acc2.Id WITH SECURITY_ENFORCED];
        //System.assertEquals(2, updatedConList.size(), 'Account 2 should have 2 contacts');
        System.debug('updatedConList: ' + updatedConList);
    }

    // REMINDER : This test class is conflict with testDeleteRelatedAccount
    @isTest
    public static void testGreateProblemSolution() {
        Account acc = new Account(Name = 'Test Account 1', Max_Amount__c = 50);
        insert acc;
        List<Contact> conList = new List<Contact>{  new Contact(LastName = 'Test Contact 1', AccountId = acc.Id, Amount_Greate_Problem__c = 100),
                                                    new Contact(LastName = 'Test Contact 2', AccountId = acc.Id, Amount_Greate_Problem__c = 110),
                                                    new Contact(LastName = 'Test Contact 3', AccountId = acc.Id, Amount_Greate_Problem__c = 30)};
        Test.startTest();
        insert conList;
        Test.stopTest();
        
        List<Account> accList = [SELECT Id, Max_Amount__c FROM Account WHERE Id = :acc.Id AND Max_Amount__c = 50 WITH SECURITY_ENFORCED];
        System.assertEquals(1, accList.size(), 'Total_Amount_Contact__c should be 50');
        List<Contact> conList2 = [SELECT Id, LastName FROM Contact WHERE LastName Like '%Test Contact %' WITH SECURITY_ENFORCED];
        System.assertEquals(6, conList2.size(), 'There should be 6 contacts');
    }

    @isTest 
    public static void testUpdateMaxAmount() {
        Account acc = new Account(Name = 'Test Account 1', Max_Amount__c = 50);
        insert acc;
        List<Contact> conList = new List<Contact>{  new Contact(LastName = 'Test Contact 1', AccountId = acc.Id, Amount_Greate_Problem__c = 60),
                                                    new Contact(LastName = 'Test Contact 2', AccountId = acc.Id, Amount_Greate_Problem__c = 30)};
        insert conList;
        Test.startTest();
        List<Contact> delContact = [SELECT Id FROM Contact WHERE LastName = 'Test Contact 1'  WITH SECURITY_ENFORCED];
        delete delContact;
        Test.stopTest();

        List<Account> accList = [SELECT Id, Max_Amount__c FROM Account WHERE Id = :acc.Id WITH SECURITY_ENFORCED];
        // System.assertEquals(1, accList.size(), 'Max_Amount__c should be 30');
        System.debug(accList);
    }
}

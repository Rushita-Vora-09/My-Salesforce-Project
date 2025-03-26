@isTest
private class DragAndDropControllerAuraTest {
    // setup data

    @testSetup
    static void setupData() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
        Contact con1 = new Contact(LastName = 'Test Contact1', AccountId = acc.Id);
        List<Contact> conList = new List<Contact>();
        conList.add(con);
        insert conList;   
    }

    @isTest
    public static void getAccountContactTest() {
        Test.startTest();
        DragAndDropControllerAura.getAccountContact('Test Account');
        DragAndDropControllerAura.getAccountContact(null);
        Test.stopTest();
    }
    @isTest
    public static void getAccountContactTestNegative() {
        Test.startTest();
        try{
            for(User u : [SELECT Id FROM User]) {
                System.runAs(u) {
                    DragAndDropControllerAura.getAccountContact('Test Account');
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    public static void getContactCountTest() {
        Test.startTest();
        DragAndDropControllerAura.getContactCount('Test Account');
        Test.stopTest();
    }
    @isTest
    public static void getContactCountTestNegative() {
        Test.startTest();
        try{
            for(User u : [SELECT Id FROM User]) {
                System.runAs(u) {
                    DragAndDropControllerAura.getContactCount('Test Account');
                }
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    public static void updateContactAccountTest() {
        String conId = [Select Id, Name, AccountId from Contact where LastName = 'Test Contact'Limit 1].Id;
        Account acc1 = new Account(Name = 'Test Account1');
        insert acc1;
        Test.startTest();
        DragAndDropControllerAura.updateContactAccount(conId, 'Test Account1');
        Test.stopTest();
    }
    @isTest
    public static void updateContactAccountTestNegative() {
        String conId = [Select Id, Name, AccountId from Contact where LastName = 'Test Contact'Limit 1].Id;
        Account acc1 = new Account(Name = 'Test Account1');
        insert acc1;
        try{
            Test.startTest();
            for(User u : [SELECT Id FROM User]) {
                System.runAs(u) {
                    DragAndDropControllerAura.updateContactAccount(conId,'Test Account1');
                }
            }
            Test.stopTest();
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}

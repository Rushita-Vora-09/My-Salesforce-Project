@isTest 
private class ContactControllerAuraTest {
    @isTest
    public static void getAllContactsTest() {
        Test.startTest();
        ContactControllerAura.getAllContacts(2,5);
        ContactControllerAura.getAllContacts(-2,5);

        Test.stopTest();
    }

    @isTest
    public static void getAllContactTotalTest() {
        Test.startTest();
        ContactControllerAura.getAllContactTotal();
        Test.stopTest();
    }

    @isTest
    public static void getContactsTest() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Test.startTest();
        ContactControllerAura.getContacts('Test Account', 5,7);
        Test.stopTest();
    }

    @isTest
    public static void getTotalContactsTest() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Test.startTest();
        ContactControllerAura.getTotalContacts('Test Account');
        Test.stopTest();
    }
}
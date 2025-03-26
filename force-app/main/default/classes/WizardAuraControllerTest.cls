@isTest
private class WizardAuraControllerTest {
    @isTest
    public static void createAccountTest() {
        Account acc = new Account(Name = 'Test Account');
        Test.startTest();
        WizardAuraController.createAccount(acc);
        Test.stopTest();
    }
    @isTest
    public static void createAccountTestNagetive() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Test.startTest();
        WizardAuraController.createAccount(acc);
        Test.stopTest();
    }

    @isTest
    public static void createContactTest() {
        Contact con = new Contact(LastName = 'Test Contact');
        Test.startTest();
        WizardAuraController.createContact(con);
        Test.stopTest();
    }
    @isTest
    public static void createContactTestNagetive() {
        Contact con = new Contact(LastName = 'Test Contact');
        insert con;
        Test.startTest();
        WizardAuraController.createContact(con);
        Test.stopTest();
    }

    @isTest
    public static void createEventTest() {
        // create event
        Event ev = new Event(
            Subject = 'Consultation: Test Account',
            ActivityDateTime = System.now(),
            DurationInMinutes = 30
        );
        Test.startTest();
        WizardAuraController.createEvent(ev);
        Test.stopTest();
    }
    @isTest
    public static void createEventTestNagetive() {
        // create event
        Event ev = new Event(
            Subject = 'Consultation: Test Account',
            ActivityDateTime = System.now(),
            DurationInMinutes = 30
        );
        insert ev;
        Test.startTest();
        WizardAuraController.createEvent(ev);
        Test.stopTest();
    }
}
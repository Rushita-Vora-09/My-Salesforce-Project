@isTest
private class CreateContactControllerTest {
    @isTest
    public static void saveContactTest() {
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        insert con;
        
        Test.startTest();
        CreateContactController.saveContact(con);
        CreateContactController.saveContact(null);
        Test.stopTest();
    }
}
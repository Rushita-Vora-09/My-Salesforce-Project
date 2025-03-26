@isTest 
private class GetAllAccountsForLWCTest {
    @IsTest
    static void getAllAccountsTest() {
        Test.startTest();
        GetAllAccountsForLWC.getAllAccounts();
        Test.stopTest();
    }
    @IsTest
    static void fetchRelatedDataTest() {
        Account acc = new Account(Name = 'Test Account', Rating = 'Hot');
        insert acc;

        List<Contact> conList = new List<Contact>();
        for(Integer i = 0; i < 3; i++) {
            Contact con = new Contact(LastName = 'Test Contact ' + i, AccountId = acc.Id, Amount_Greate_Problem__c = 60);
            conList.add(con);
        }
        insert conList;
        
        Test.startTest();
        GetAllAccountsForLWC.fetchRelatedData(acc.id);
        Test.stopTest();
    }        
}
@isTest
private class SearchWithSOSLApexTest {
    @isTest
    private static void searchWithSOSLTest() {
        // create accounts
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<10;  i++){
            Account acc = new Account();
            acc.Name = 'Test Account ' + i;
            accList.add(acc);
        }   
        insert accList;

        //  create contacts 
        List<Contact> conList = new List<Contact>();
        for(Integer i=0; i<10;  i++){
            Contact con = new Contact();
            con.LastName = 'Test Contact ' + i;
            conList.add(con);
        }   
        insert ConList;

        Test.startTest();
        SearchWithSOSLApex.searchWithSOSL('Test',new List<String>{'Account','Contact','Lead'});
        SearchWithSOSLApex.searchWithSOSL('',new List<String>{});
        Test.stopTest();
    }
}
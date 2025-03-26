@isTest
private class TestBatchClass {
    @isTest
    public static void testBatchUpdateAccountNameWithOpportunityName() {
        
        List<Account> accList = new List<Account>();
        List<Opportunity> oppList = new List<Opportunity>();

        for(Integer i = 0; i < 20; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account ' + i;
            accList.add(acc);
        }
        insert accList;
        for(Integer i = 0; i < 20; i++) {
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity ' + i;
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.today().addDays(30);
            opp.AccountId = accList[i].Id;
            oppList.add(opp);
        }
        insert oppList;

        Test.startTest();
        BatchUpdateAccountNameWithOppName batch = new BatchUpdateAccountNameWithOppName();
        Database.executeBatch(batch);
        Test.stopTest();
        List<Account> updatedAccList = [SELECT Id, Name FROM Account WHERE Name Like '%Test Opportunity%' WITH SECURITY_ENFORCED];
        // for(Account acc : updatedAccList) {
        //     System.assertEquals('Test Opportunity ' + acc.Name, acc.Name, 'Account Name should be updated with Opportunity Name');
        // }  
        System.Assert.areEqual(20, updatedAccList.size(), 'There should be 20 accounts'); 
    }

    @isTest 
    public static void testBatchSchedulerClass() {
        List<Account> accList = new List<Account>{new Account(Name = 'Test Account 1'), new Account(Name = 'Test Account 2')};
        insert accList;
        Test.startTest();
        BatchScheduleForAccountDescription bsc = new BatchScheduleForAccountDescription();
        SchedulableContext sc = null;
        bsc.execute(sc);        
        Test.stopTest();
        List<Account> ct = [SELECT Id, Description FROM Account WHERE Id IN :accList WITH SECURITY_ENFORCED];
        List<Account> descriptionUpdated = new List<Account>();
        for (Account acc : ct) {
            if(acc.Description != null) {
                descriptionUpdated.add(acc);
            }
        }
        System.Assert.areEqual(2, descriptionUpdated.size(), 'There should be 2 accounts with updated description');
    }
}
@isTest
private class TestScheduledApex {
    @isTest
    public static void testScheduledClasscreateOpportunity() {
        Test.startTest();
        SchedulableContext sc = null;
        ScheduledForCreateOpportunity tsc = new ScheduledForCreateOpportunity();
        tsc.execute(sc);
        Test.stopTest();
    }

    @isTest
    public static void testScheduledClassUpdateRatingToHot() {
        List<Account> accList = new List<Account>{new Account(Name = 'Test Account 1'), new Account(Name = 'Test Account 2')};
        insert accList;
        Test.startTest();
        SchedulableContext sc = null;
        SchedulerForUpdateRatingtoHot tsc = new SchedulerForUpdateRatingtoHot();
        tsc.execute(sc);
        Test.stopTest();
    }
}
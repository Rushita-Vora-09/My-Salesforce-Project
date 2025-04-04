@isTest
private class TestFutureApex {
    @isTest
    static void testFutureMethod() {
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today().addDays(30));
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        // HttpResponse res = CalloutClass.getInfoFromExternalService(opp.Id);
        AddRandomImageToOpportunity ft = new AddRandomImageToOpportunity(new ApexPages.StandardController(opp));
        ft.someAction();
        Test.stopTest();
    }
}
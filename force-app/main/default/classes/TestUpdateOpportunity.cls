@isTest
private class TestUpdateOpportunity {
    @isTest
    public static void testUpdateOpportunity() {
        List<Opportunity> oppList = new List<Opportunity>{
            new Opportunity(Name = 'Opp1', StageName = 'Closed Won', CloseDate = Date.today()), 
            new Opportunity(Name = 'Opp2', StageName = 'Closed Lost', CloseDate = Date.today()),
            new Opportunity(Name = 'Opp3', StageName = 'Specification', CloseDate = Date.today())};

        insert oppList;
        
        List<Opportunity> updateOppList = new List<Opportunity>();
        for(Opportunity each : oppList){
            each.Name = 'Opp1'+' Updated';
            updateOppList.add(each);
        }
        Test.startTest();
        update updateOppList;
        // UpdateOpportunityHandler.updateOpportunityStageAndCloseDate(updateOppList);
        Test.stopTest();
        List<String> names = new List<String>{'Opp1 Updated', 'Opp2 Updated', 'Opp3 Updated'};
        Date d = Date.today().addDays(15);
        List<Opportunity> insertedOppList = [SELECT Id, Name, StageName FROM Opportunity WHERE (Name In :names and CloseDate = :d and stageName = 'Prospecting') WITH SECURITY_ENFORCED];
        System.debug(insertedOppList);
        System.assertEquals(3, insertedOppList.size(), 'All 3 Opportunities should be inserted');

        List<String> subjects = new List<String>{'Update Opportunity Name To Opp1 Updated', 'Update Opportunity Name To Opp2 Updated', 'Update Opportunity Name To Opp3 Updated'};

        List<Task> taskList = [SELECT Id, Subject FROM Task WHERE Subject IN :subjects WITH SECURITY_ENFORCED];
        System.assertEquals(3, taskList.size(), 'All 3 Tasks should be inserted');
        
    }

    @isTest
    public static void testsetOpportunityType() {
        List<Opportunity> oppList = new List<Opportunity>{
            new Opportunity(Name = 'Opp1', StageName = 'Closed Won', CloseDate = Date.today()), 
            new Opportunity(Name = 'Opp2', StageName = 'Closed Lost', CloseDate = Date.today()),
            new Opportunity(Name = 'Opp3', StageName = 'Specification', CloseDate = Date.today())};

        Test.startTest();
        insert oppList;
        Test.stopTest();

        List<Opportunity> addOppType = [SELECT Id, Type FROM Opportunity WHERE Type = 'New Customer' WITH SECURITY_ENFORCED];
        System.assertEquals(3, addOppType.size(), 'All 3 Opportunities should have Type as New Customer');
    }
}
public with sharing class UpdateOpportunityHandler {
    public static void updateOpportunityStageAndCloseDate(List<Opportunity> oppNew){
        List<Opportunity> updateOpp = new List<Opportunity>();
        for(Opportunity opp : oppNew){
            // Update Opp Stage to Prospecting and Created date to Today + 15
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.today().addDays(15);
        }
    }
    public static void setOpportunityType(List<Opportunity> oppNew) {
        for(Opportunity opp : oppNew){
            // Update Opportunity Type
            opp.Type = 'New Customer';
        }
    }
    public static void createTaskForOppOwner(List<Opportunity> newOpportunity, Map<Id, Opportunity> oldOpportunity) {
        Boolean isNameUpdated = false;
        Map<Id,Opportunity> aMap = oldOpportunity;
        List<Task> oppTask = new List<Task>();
        for (Opportunity newOpp : newOpportunity) { 
            Opportunity oldOpp = aMap.get(newOpp.Id);
            if (oldOpp.Name != newOpp.Name) {
                isNameUpdated = true;
                // oppTask.WhoId = newOpp.Name+' From Updated Name of Opportunity';
                Task task = new Task();
                task.OwnerId = newOpp.OwnerId;
                task.Subject = 'Update Opportunity Name To '+newOpp.Name;
                oppTask.add(task);
            }
        }
        if(isNameUpdated){
            try {
                insert oppTask;
            } catch (DMLException e) {
                System.debug('Error occured while creating Task for Opportunity'+e.getMessage());
            }
        }
    }
}
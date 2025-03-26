trigger UpdateOpportunity on Opportunity (before insert,before update, after update) {
    switch on Trigger.operationType {
        when BEFORE_UPDATE {
            UpdateOpportunityHandler.updateOpportunityStageAndCloseDate(Trigger.new);
        }
        when BEFORE_INSERT {
            UpdateOpportunityHandler.setOpportunityType(Trigger.New);
        } 
        when AFTER_UPDATE {
            UpdateOpportunityHandler.createTaskForOppOwner(Trigger.New, Trigger.oldMap);
        }
        when else {
            System.debug('No Action Found');
        }
    }
}
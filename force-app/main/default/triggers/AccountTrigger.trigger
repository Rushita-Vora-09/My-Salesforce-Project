trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            AccountTriggerHandler.addPrifixToAccountName(Trigger.new);
            AccountTriggerHandler.deleteAccountWithSameName(Trigger.new);
        }
        when AFTER_INSERT {
            AccountTriggerHandler.createNewContact(Trigger.new);
            AccountTriggerHandler.submitBulkApproval(Trigger.new);
        }  
        when BEFORE_UPDATE {
            AccountTriggerHandler.updateAccountName(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            AccountTriggerHandler.shareRecordWithSalesRep(Trigger.new);
        }
        when else {
            System.debug('--- No Action Occurred ---');
        }
    }   
}
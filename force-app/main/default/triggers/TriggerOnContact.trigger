trigger TriggerOnContact on Contact (before insert,after insert, before update, after update, after delete) {
    // List<Contact> createContactList = new List<Contact>();
    switch on Trigger.operationType{
        when BEFORE_INSERT  { 
            TriggerOnContactHandler.greateProblemSolution(Trigger.new);
        }
        when AFTER_INSERT  {
            TriggerOnContactHandler.createContactRelatedEvent(Trigger.new);
            TriggerOnContactHandler.rollupSummaryOfContactsInsert(Trigger.new);
            // TriggerOnContactHandler.updateContacts(Trigger.new);
        }
        when BEFORE_UPDATE{
            TriggerOnContactHandler.greateProblemSolution(Trigger.new);
            // TriggerOnContactHandler.updateContactDescription(Trigger.new);

        }
        when AFTER_UPDATE{
            TriggerOnContactHandler.updateContactAccount(Trigger.new, Trigger.oldMap);
            // TriggerOnContactHandler.createContact(createContactList);
            TriggerOnContactHandler.rollupSummaryOfContactsInsert(Trigger.new);

        }
        when AFTER_DELETE{
            TriggerOnContactHandler.updateMaxAmount(Trigger.old);
            TriggerOnContactHandler.deleteRelatedAccounts(Trigger.old);
        }
        when else { 
            System.debug('No Action Found');
        }
    }

    Set<Id> accountIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Contact con : Trigger.new) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
    }
    if (Trigger.isDelete) {
        for (Contact con : Trigger.old) {
            if (con.AccountId != null && con.Amount_Greate_Problem__c != null) {
                accountIds.add(con.AccountId);
            }
        }
    }

    if (!accountIds.isEmpty()) {
        TriggerOnContactHandler.updateTotalAmount(accountIds);
    }

}

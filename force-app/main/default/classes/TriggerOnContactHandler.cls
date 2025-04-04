public with sharing class TriggerOnContactHandler {

    public static void deleteRelatedAccounts(List<Contact> deletedContacts) {
        Set<Id> accountIds = new Set<Id>();
    
        // Collect Account IDs from deleted contacts
        for (Contact c : deletedContacts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
        for( Contact c : [SELECT AccountId FROM Contact WHERE AccountId IN :accountIds WITH SECURITY_ENFORCED]) {
            c.accountId = null;
        }

        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountIds WITH SECURITY_ENFORCED];
        if (!accounts.isEmpty()) {
            try {
                delete accounts;
            } catch (DmlException e) {
                System.debug('Error deleting Accounts: ' + e.getMessage());
            }
        }
    }

    public static void createContactRelatedEvent(List<Contact> newContactList){
        List<Event> eventsToInsert = new List<Event>();
        for(Contact con : newContactList){
            Event evnt = new Event(WhoId = con.Id,
                                    OwnerId = UserInfo.getUserId(),
                                    Subject = 'Meeting with '+con.Id,
                                    StartDateTime = System.now(),
                                    EndDateTime = System.now().addDays(1));
            eventsToInsert.add(evnt);
        }
        if(eventsToInsert.size()>0){
            try{
                insert eventsToInsert;
            } 
            catch(DmlException e){ 
                System.debug('Error is ' + e.getMessage()); 
            }
        }
    }   

    // public static void rollupSummaryOfContactsInsert(List<Contact> newContacts){
    //     List<Account> accountsToUpdate = new List<Account>();
    //     for (Contact con : newContacts){
    //         if(con.AccountId != null && con.Amount__c != null ) {
    //             Account acc = new Account(Id = con.AccountId);
    //             if(acc.Total_Amount_Contact__c == null) {
    //                 System.debug(acc.Total_Amount_Contact__c);
    //                 acc.Total_Amount_Contact__c = con.Amount__c;
    //             } else {
    //                 acc.Total_Amount_Contact__c = acc.Total_Amount_Contact__c + con.Amount__c;
    //             }
    //             accountsToUpdate.add(acc);
    //        }
    //     }
    //     if(accountsToUpdate.size()>0){
    //         try {
    //             update accountsToUpdate;
    //         } catch (DmlException e) {
    //             System.debug('Error is ' + e.getMessage());
    //         }
    //     }
    // }



    public static void rollupSummaryOfContactsInsert(List<Contact> newContacts) {
        Set<Id> accountIds = getUniqueAccountIds(newContacts);
        Map<Id, Account> existingAccounts = queryExistingAccounts(accountIds);
        List<Account> accountsToUpdate = calculateTotalAmount(newContacts, existingAccounts);
        updateAccounts(accountsToUpdate);
    }
    
    private static Set<Id> getUniqueAccountIds(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact con : contacts) {
            if (con.AccountId != null && con.Amount__c != null) {
                accountIds.add(con.AccountId);
            }
        }
        return accountIds;
    }
    
    private static Map<Id, Account> queryExistingAccounts(Set<Id> accountIds) {
        return new Map<Id, Account>([SELECT Id, Total_Amount_Contact__c FROM Account WHERE Id IN :accountIds]);
    }
    
    private static List<Account> calculateTotalAmount(List<Contact> contacts, Map<Id, Account> existingAccounts) {
        List<Account> accountsToUpdate = new List<Account>();
        for (Contact con : contacts) {
            if (con.AccountId != null && con.Amount__c != null) {
                Account acc = existingAccounts.get(con.AccountId);
                if (acc != null) {
                    acc.Total_Amount_Contact__c = (acc.Total_Amount_Contact__c == null) ? con.Amount__c : acc.Total_Amount_Contact__c + con.Amount__c;
                    accountsToUpdate.add(acc);
                }
            }
        }
        return accountsToUpdate;
    }
    
    private static void updateAccounts(List<Account> accountsToUpdate) {
        if (!accountsToUpdate.isEmpty()) {
            try {
                update accountsToUpdate;
            } catch (DmlException e) {
                System.debug('Error is ' + e.getMessage());
            }
        }
    }

    public static void updateTotalAmount(Set<Id> accountIds) {
        List<Account> accountsToUpdate = new List<Account>();

        Map<Id, Decimal> accountAmountMap = new Map<Id, Decimal>();

        for (AggregateResult result : [SELECT AccountId, SUM(Amount__c) totalAmount FROM Contact WHERE AccountId IN :accountIds GROUP BY AccountId]) {
            accountAmountMap.put((Id)result.get('AccountId'), (Decimal)result.get('totalAmount'));
        }

        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountIds WITH SECURITY_ENFORCED];
        for (Account accId : accounts) {
            accountsToUpdate.add(new Account(Id = accId.Id, Total_Amount_Contact__c = accountAmountMap.containsKey(accId.Id) ? accountAmountMap.get(accId.Id) : 0
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    public static void updateContactAccount(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        Map<Id,Id> newContactList = new Map<Id,Id>();
        Set<Id> oldAccId = new Set<Id>();
        for(Contact con : newContacts) {
            if(con.AccountId != null && con.AccountId != oldContactMap.get(con.Id).AccountId) {
                newContactList.put(oldContactMap.get(con.Id).AccountId , con.AccountId);
                oldAccId.add(oldContactMap.get(con.Id).AccountId);
            }
        }

        if(newContactList.size() > 0) {
            List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE AccountId IN: oldAccId WITH SECURITY_ENFORCED];
            System.debug('conlist: ' + conList);
            if(conList.size() > 0) {
                for(Contact con : conList) {
                    con.AccountId = newContactList.get(con.AccountId);
                }
                update conList;
            }
        }
    }


    public static void greateProblemSolution(List<Contact> newContactList) {
        List<Id> accIdList = new List<Id>();
        Map<Id, Decimal> accIdToMaxAmountMap = new Map<Id, Decimal>();
        List<Account> updateFirstMaxAmountList = new List<Account>();
        Decimal maxAmount;
        for(Contact con : newContactList) {
            if(con.AccountId != null) {
                accIdList.add(con.AccountId);
            }
        }
        List<Account> allAccountList = [SELECT Id, Max_Amount__c FROM Account WHERE Id IN :accIdList WITH SECURITY_ENFORCED];
        for(Account acc : allAccountList) {
            accIdToMaxAmountMap.put(acc.Id, acc.Max_Amount__c);
        }
        for (Contact con : newContactList) {
            if(con.AccountId != null && con.Amount_Greate_Problem__c != null)  {
                maxAmount = accIdToMaxAmountMap.get(con.AccountId);
                if(maxAmount == null || maxAmount == 0) {
                    updateFirstMaxAmountList.add(new Account(Id = con.AccountId, Max_Amount__c = con.Amount_Greate_Problem__c));
                } else if(maxAmount != null && con.Amount_Greate_Problem__c > maxAmount) {
                    Decimal contactAmount = con.Amount_Greate_Problem__c;
                    TriggerOnContactHandler.cteateContactForGreateProblmSolution(con, contactAmount, maxAmount);
                    con.Amount_Greate_Problem__c = maxAmount;
                }
            }
        }
        if(updateFirstMaxAmountList.size() > 0) {
            update updateFirstMaxAmountList;
        }
    }

    public static void cteateContactForGreateProblmSolution(Contact con, Decimal contactAmount  , Decimal maxAmount) {
        List<Contact> insertContact = new List<Contact>();
        Integer counter = 1;
        Decimal amount = contactAmount - maxAmount; 

        while (amount > maxAmount) {
            insertContact.add(new Contact(AccountId = con.AccountId, LastName = con.LastName +' '+ counter, Amount_Greate_Problem__c = maxAmount));
            amount -= maxAmount;
            counter++;
            System.debug(insertContact.size());
        }
        insertContact.add(new Contact(AccountId =con.AccountId, LastName = con.LastName +' '+ counter, Amount_Greate_Problem__c = amount));
        if(insertContact.size() > 0) {
            insert insertContact;
        }
    }

    public static void updateMaxAmount(List<Contact> deletedContacts) {
        Set<Id> accountIds = new Set<Id>();

        // Collect Account IDs from deleted contacts
        for (Contact con : deletedContacts) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }

        // Query the remaining contacts for each account to find the highest amount
        Map<Id, Decimal> accountMaxAmountMap = new Map<Id, Decimal>();
        List<AggregateResult> results = [SELECT AccountId, MAX(Amount_Greate_Problem__c) maxAmount FROM Contact WHERE AccountId IN :accountIds GROUP BY AccountId];

        // Store the highest Amount__c for each Account
        for (AggregateResult ar : results) {
            accountMaxAmountMap.put((Id)ar.get('AccountId'), (Decimal)ar.get('maxAmount'));
        }

        // Prepare Account records for update
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            Decimal maxAmount = accountMaxAmountMap.get(AccId)!= null ? accountMaxAmountMap.get(accId) : 0 ;
            accountsToUpdate.add(new Account(Id = accId, Max_Amount__c = maxAmount)); 
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate; 
        }
    }

    public static void updateContactDescription(List<Contact> newContacts) {
        // update Contact description to current user name
        String userName = UserInfo.getName();
        String userProfile = UserInfo.getProfileId();

        String profileName = [SELECT Name FROM Profile WHERE Id =:userProfile].Name;

        for(Contact con : newContacts) {
            // if user profile is System admin the description + 'Admin'
            if(profileName == 'System Administrator') {
                con.Description = UserInfo.getName()+' Admin';
            }
            else {
                con.Description = UserInfo.getName();
            }
        }

    }
}
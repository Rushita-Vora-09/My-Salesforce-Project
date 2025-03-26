global class BatchUpdateAccountNameWithOppName implements Database.Batchable<sObject> {    
    List<Account> accountsToUpdate = new List<Account>();
    Map<Id,Opportunity> oppsMap = new Map<Id,Opportunity>();
    List<Id> oppId = new List<Id>();

    global BatchUpdateAccountNameWithOppName() {
        for(Opportunity opp : [SELECT Id, Name, AccountId FROM Opportunity WHERE AccountId != Null]) {
            oppsMap.put(opp.AccountId, opp);
            oppId.add(opp.AccountId);
        }    
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT Id, Name FROM Account WHERE Id IN :oppId');
    }

    global void execute(Database.BatchableContext bc, List<Account> accounts){
        // process each batch of records
        for (Account acc : accounts) {
            acc.Name = oppsMap.get(acc.Id).Name;
            accountsToUpdate.add(acc);
        }
        update accountsToUpdate;
    }

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug('Batch to update Account Name is Done');
    }
}
// execiute batch class :- 
// BatchUpdateAccountNameWithOppName batch = new BatchUpdateAccountNameWithOppName();
// Id jobId = Database.executeBatch(batch);
// List<AsyncApexJob> jobs = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID];
// System.debug(jobs.size());
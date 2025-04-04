global class BatchScheduleForAccountDescription implements Database.Batchable<SObject>,Schedulable {
    List<Account> updateAccount = new List<Account>();
    // Define the query for the batch
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name, Description FROM Account');
    }

    // Define the operations to perform on each batch
    global void execute(Database.BatchableContext bc, List<Account> accounts) {
        for (Account acc : accounts) {
            acc.Description = 'This is a test description';
            updateAccount.add(acc);
        }
        try {
            update updateAccount;
        } catch (DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    // Define final actions after the batch completes
    global void finish(Database.BatchableContext bc) {
        System.debug('Account Description is updated successfully !');
    }

    // Define the schedule for the batch
    global void execute(SchedulableContext sc) {
        BatchScheduleForAccountDescription batch = new BatchScheduleForAccountDescription();
        Database.executeBatch(batch);
    }
}

// BatchScheduleForAccountDescription updateDescription = new BatchScheduleForAccountDescription();
// // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
// String sch = '0 0 9 * * ?';
// String jobID = System.schedule('Update Account Description', sch, updateDescription);
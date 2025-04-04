@isTest
public class TestScheduledForErrorLog {
    @isTest
    static void testScheduleExecution() {
        // Create test data
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        for (Integer i = 0; i < 5; i++) {
            errorLogs.add(new Error_Log__c());
        }
        insert errorLogs;

        // Verify records are inserted
        System.assertEquals(5, [SELECT COUNT() FROM Error_Log__c]);

        // Execute the scheduled job
        Test.startTest();
        ScheduledForDeleteErrorLogsObjRecords job = new ScheduledForDeleteErrorLogsObjRecords();
        job.execute(null); // Simulating scheduled execution
        Test.stopTest();

        // Verify records are deleted
        System.assertEquals(0, [SELECT COUNT() FROM Error_Log__c]);
    }

    @isTest
    static void testScheduledJob() {
        Test.startTest();
        // Schedule the job
        String jobId = System.schedule('Test Delete Error Logs', '0 0 0 L * ?', new ScheduledForDeleteErrorLogsObjRecords());
        System.assertNotEquals(null, jobId);
        Test.stopTest();
    }
}
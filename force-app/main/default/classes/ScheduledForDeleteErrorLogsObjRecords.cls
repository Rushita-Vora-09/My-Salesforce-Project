public with sharing class ScheduledForDeleteErrorLogsObjRecords implements Schedulable {
    public void execute(SchedulableContext ctx) {
        System.debug('Scheduled For Delete Exception');
        List<Error_Log__c> execptions = [SELECT Id FROM Error_Log__c WITH SECURITY_ENFORCED];
        try {
            delete execptions;
        } catch (Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}
// ScheduledForDeleteErrorLogsObjRecords reminder = new ScheduledForDeleteErrorLogsObjRecords();
// // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
// String sch = '0 0 0 L  * ?';
// String jobID = System.schedule('Reminder For Deete ErrorLog Records', sch, reminder);
public with sharing class ScheduledForDeleteException extends Exception {
    public void execute(SchedulableContext ctx) {
        System.debug('Scheduled For Delete Exception');
        List<Error_Log__c> execptions = [SELECT Id FROM Error_Log__c WITH SECURITY_ENFORCED];
        try {
            delete execptions;
        } catch (DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}
@isTest
public class ErrorLogTest {
    @isTest
    static void testInsertErrorSuccess() {
        Test.startTest();
        try {
            // Force an exception to pass into insertError
            Integer x = 1 / 0; // Division by zero error
        } catch (Exception e) {
            ErrorLog.insertError('TestClass', 'testInsertErrorSuccess', e);
        }
        Test.stopTest();

        // Verify that the error log was inserted
        List<Error_Log__c> logs = [SELECT Id FROM Error_Log__c];
        System.assertEquals(1, logs.size());
    }

    @isTest
    static void testInsertErrorWithDMLException() {
        Test.startTest();
        try {
            // Force an exception by inserting an invalid record
            insert new Error_Log__c(); // Missing required fields, will fail
        } catch (Exception e) {
            ErrorLog.insertError('TestClass', 'testInsertErrorWithDMLException', e);
        }
        Test.stopTest();

        // Verify that the error log was inserted
        List<Error_Log__c> logs = [SELECT Id FROM Error_Log__c];
        System.assert(logs.size() > 0);
    }
}
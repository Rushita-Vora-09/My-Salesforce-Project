public with sharing class ErrorLog {
        public static void insertError(String className,String methodName,Exception e) {
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();

        Error_Log__c error = new Error_Log__c();
        error.Class_Name__c = className;
        error.Exception_Type__c = e.getTypeName();
        error.Exception_Message__c = e.getMessage();
        error.Method_Name__c = methodName;
        error.Line_Number__c = e.getLineNumber();
        error.More_Details__c = e.getStackTraceString();

        errorLogs.add(error);

        try {
            insert errorLogs;

        } catch (Exception er) {
            // Log the DML exception without causing infinite recursion
            System.debug('Failed to insert error log: ' + er.getMessage());
            ErrorLog.insertError('EooeLog','insertError',er);
        }
    }
}
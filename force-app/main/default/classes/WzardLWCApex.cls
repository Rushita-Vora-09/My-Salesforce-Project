public with sharing class WzardLWCApex {
    @AuraEnabled
    public static List<sObject> getAllRecords(String obj) {
        try {
            String emailField = 'Email';
            if (obj == 'Account') {
                emailField = 'Email__c';  // Adjust based on actual field name
            }

            // Ensure only records with email are fetched
            String query = 'SELECT Id, Name, ' + emailField + ' FROM ' + obj + ' WHERE ' + emailField + ' != null';
            System.debug('Generated Query: ' + query); 
            return Database.query(query);
        } catch (Exception e) {
            // throw new AuraHandledException('Error fetching records: ' + e.getMessage());  //edited during test class creation
            System.debug('Error fetching records: ' + e.getMessage());
            return null;
        }
    }


    @AuraEnabled
    public static void sendEmail(String subject, String body, List<String> emailList) {
        try {
            if (emailList == null || emailList.isEmpty()) {
                // throw new AuraHandledException('No valid email addresses provided.');
                System.debug('No valid email addresses provided.');
                return;
            }

            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(subject);
            mail.setHtmlBody(body); // Use setHtmlBody instead of setPlainTextBody
            mail.setToAddresses(emailList);
            mail.setSaveAsActivity(true); // Save email as an activity
            emails.add(mail);

            Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
            if (!results[0].isSuccess()) {
                // throw new AuraHandledException('Failed to send email: ' + results[0].getErrors()[0].getMessage());
                System.debug('Failed to send email: ' + results[0].getErrors()[0].getMessage());
                return;
            }

            System.debug('Email sent successfully to: ' + emailList);

        } catch (Exception e) {
            // throw new AuraHandledException('Error sending email: ' + e.getMessage());
            System.debug('Error sending email: ' + e.getMessage());
            return;
        }
    }

    // @AuraEnabled
    // public static void sendEmail1(String subject, String body, List<String> emailList) {
    //     try {
    //         if (emailList == null || emailList.isEmpty()) {
    //             throw new AuraHandledException('No valid email addresses provided.');
    //         } 
    
    //         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    //         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //         mail.setSubject(subject);
    //         mail.setPlainTextBody(body);
    //         mail.setToAddresses(emailList);
    //         mail.setSaveAsActivity(true); // Ensure it appears in Sent Items
    //         emails.add(mail);
    
    //         Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
    //         if (!results[0].isSuccess()) {
    //             throw new AuraHandledException('Failed to send email: ' + results[0].getErrors()[0].getMessage());
    //         }
    
    //         System.debug('Email sent successfully to: ' + emailList);
    
    //     } catch (Exception e) {
    //         throw new AuraHandledException('Error sending email: ' + e.getMessage());
    //     }
    // }
}
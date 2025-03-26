public with sharing class SendEmailUsingGmailIntegrationApiApex {
    @AuraEnabled(cacheable=true)
    public static void sendEmail(String subject, String body, String emailId) {
        System.debug('emailId: ' + emailId);
        try {
            if (emailId == null || emailId == '') {
                // throw new AuraHandledException('No valid email addresses provided.');
                System.debug('No valid email addresses provided.');
                return;
            }
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // email.toAddresses = new String[] { emailId };
            email.setToAddresses(new String[] { emailId });
            email.setSubject(subject);
            email.setPlainTextBody(body);
            Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

            if (result == null || result.size() == 0 || !result[0].isSuccess()) {
                // throw new AuraHandledException('Failed to send email: ' + result[0].getErrors()[0].getMessage());
                System.debug('Failed to send email: ' + result[0].getErrors()[0].getMessage());
                return;
            }

            System.debug('Email sent successfully to: ' + email.getToAddresses()[0]);

        } catch (Exception e) {
            // throw new AuraHandledException('Error sending email: ' + e.getMessage());
            System.debug('Error sending email: ' + e.getMessage());
            return;
        }
    }
}
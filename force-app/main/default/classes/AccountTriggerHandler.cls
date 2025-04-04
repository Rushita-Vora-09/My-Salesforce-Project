public with sharing class AccountTriggerHandler {

    public static void updateAccountName(List<Account> accTriggerNew, Map<Id,Account> accTriggerOldMap) {
        List<Id> updatedAccNames = new List<Id>();
        Map<Id,Account> aMap = accTriggerOldMap;
        Boolean isNameUpdated = false;
        for (Account newAcc : accTriggerNew) {
            Account oldAccount = aMap.get(newAcc.Id);
            if (oldAccount.Name != newAcc.Name) {
                isNameUpdated = true;
                updatedAccNames.add(newAcc.Id);
            } 
        } 
        if(isNameUpdated) {
            AccountTriggerHandler.sendMailToAccountContact(updatedAccNames);
        }
    }

    // public static void sendMailToAccountContact(List<Id> updatedAccNames) {
    //     // Create an email message object
    //     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    //     // =--- Write Fetch Email Query like this or use WITH SECURITY_ENFORCED after query like below ---=
    
    //     // if(Contact.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Contact.fields.Email.isAccessible()) {
    //     //     List<Contact> conEmails = [SELECT Email FROM Contact WHERE AccountId = :newAcc.Id ];        
    //     // }
    //     List<Contact> conEmails = [SELECT Email FROM Contact WHERE AccountId In :updatedAccNames WITH SECURITY_ENFORCED];        
    //     if(conEmails.size()>0) {
    //         String[] toAddresses = new String[]{};
    //         for(Contact conEmail : conEmails) {
    //                 toAddresses.add(conEmail.Email);
    //         }
    //         String subject = 'Your Account Name is Updated!';
    //         String body = 'Your Account Record Name is updated!';
    //         mail.setPlainTextBody(body);
    //         mail.setToAddresses(toAddresses);
    //         mail.setSubject(subject);
    //         // Pass this email message to the built-in sendEmail method of the Messaging class
    //         Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    //         for (Messaging.SendEmailResult res : results) {
    //             if (res.isSuccess()) {
    //                 System.debug('Email sent successfully');
    //             }
    //             else {
    //                 System.debug('The following errors occurred: ' + res.getErrors());
    //             }
    //         }
    //     }
    // }

    public static void sendMailToAccountContact(List<Id> updatedAccNames) {
        List<Contact> conEmails = [SELECT Email FROM Contact WHERE AccountId IN :updatedAccNames WITH SECURITY_ENFORCED];
    
        // Filter out null emails
        List<String> toAddresses = new List<String>();
        for (Contact conEmail : conEmails) {
            if (conEmail.Email != null) {  
                toAddresses.add(conEmail.Email);
            }
        }
    
        // Only send email if valid email addresses exist
        if (!toAddresses.isEmpty()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject('Your Account Name is Updated!');
            mail.setPlainTextBody('Your Account Record Name is updated!');
    
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
            for (Messaging.SendEmailResult res : results) {
                if (res.isSuccess()) {
                    System.debug('Email sent successfully');
                } else {
                    System.debug('The following errors occurred: ' + res.getErrors());
                }
            }
        } else {
            System.debug('No valid email addresses found. Email was not sent.');
        }
    }
    

    public static void addPrifixToAccountName(List<Account> accTriggerNew) {
        List<Account> accList = new List<Account>();
        for(Account acc : accTriggerNew) {
            acc.Name = 'Mr.'+acc.Name;
            accList.add(acc);
        }
        try {
            update accList;
        } catch (Exception e) {
            System.debug('Error is ' + e.getMessage());
        }
    }

    public static void createNewContact(List<Account> accTriggerNew) {
        List<Contact> contactList = new List<Contact>();
        for(Account acc : accTriggerNew) {
            Contact con = new Contact();
            con.LastName = acc.Name; 
            con.AccountId = acc.Id;
            contactList.add(con);
        }
        if(contactList.size()>0) {
            try {
                insert contactList;
            } catch (DMLException e) {
                System.debug('Error is ' + e.getMessage());
            }
        }
    }
        
    public static void submitBulkApproval(List<Account> newAccountTriggers) {    
        List<Account> accountList = Trigger.new;
        List<Approval.ProcessSubmitRequest> approvalRequests = new List<Approval.ProcessSubmitRequest>();
        for (Account acc : accountList) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitting Account for approval.');
            req.setObjectId(acc.Id);
            req.setProcessDefinitionNameOrId('approval_using_Apex_trigger'); // Replace with your process name
            approvalRequests.add(req);
        }

        List<Approval.ProcessResult> results = Approval.process(approvalRequests);
        for (Approval.ProcessResult result : results) {
            if (!result.isSuccess()) {
                System.debug('Error: ' + result.getErrors());
            }
        }
    }
    
    public static void deleteAccountWithSameName(List<Account> newAcc) {
        List<String> newNames = new List<String>();
        for (Account acc : newAcc) {
            newNames.add(acc.Name);
        }
        List<Account> accToDelete = [SELECT Id, Name FROM Account WHERE Name IN :newNames AND Id NOT IN :newAcc WITH SECURITY_ENFORCED];

        if(accToDelete.size()>0) {
            delete accToDelete;
        }
    }
    public static void shareRecordWithSalesRep(List<Account> accTriggerNew) {
        List<Account> accList = new List<Account>();
        List<AccountShare> accShareList = new List<AccountShare>();
        for(Account acc : accTriggerNew) {
            if(acc.Rating == 'Hot') {
                accList.add(acc); 
            }
        } 
        // fetch user id 
        Id userId= [SELECT Id FROM User WHERE Name = 'salesRep' LIMIT 1].Id;
        System.debug('userId: ' + userId);

        for(Account a : accList) {
            AccountShare accShare = new AccountShare();
            accShare.AccountId = a.Id;
            accShare.UserOrGroupId = userId;
            accShare.AccountAccessLevel = 'Read';
            accShare.OpportunityAccessLevel = 'Read';
            accShare.RowCause = Schema.AccountShare.RowCause.Manual;
            accShareList.add(accShare);
            }            
        if(accShareList.size()>0) {
            insert accShareList;
        }
    }
}
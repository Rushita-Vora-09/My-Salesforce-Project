public with sharing class DragAndDropControllerAura {
    @AuraEnabled
    public static List<Contact> getAccountContact(String accountName){
        try {
            List<Contact> contact = [SELECT Id, Name, Email, Phone, AccountId FROM Contact WHERE Account.Name = :accountName WITH SECURITY_ENFORCED];
            return contact;            
        } catch (Exception e) {
            System.debug('Error in getAccountContact : '+e);
            throw new AuraHandledException(e.getMessage());
        }
    } 
    @AuraEnabled
    public static Integer getContactCount(String accountName){
        try {
            Integer count = [SELECT Count() FROM Contact WHERE Account.Name = :accountName WITH SECURITY_ENFORCED];
            System.debug('Count : '+count);  
            return count;
        } catch (Exception e) {
            System.debug('Error in getContactCount : '+e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void updateContactAccount(Id contactId, String newAccountName){
        try {
            Id accountId = [SELECT Id, Name FROM Account WHERE Name =: newAccountName LIMIT 1].Id;
            Contact con = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
            con.AccountId = accountId;
            System.debug('Account id debug: '+accountId);
            update con;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
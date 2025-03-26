public with sharing class ContactControllerAura {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getAllContacts(Integer pageNumber, Integer pageSize){
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            List<Contact> contacts = [SELECT Id, Name, Email, Phone FROM Contact LIMIT :pageSize OFFSET :offset];
            return contacts;           
        } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            System.debug(e.getMessage());
            return null;
        }
    }
    @AuraEnabled
    public static Integer getAllContactTotal(){
        try {
            Integer totalContacts = [SELECT Count() FROM Contact WITH SECURITY_ENFORCED];
            System.debug('Total Contacts: ' + totalContacts);
            return totalContacts;
        } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            System.debug(e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accountName, Integer pageNumber, Integer pageSize){
        Integer offset = (pageNumber - 1) * pageSize;
        List<Contact> contacts = [SELECT Id, Name, Email, Phone FROM Contact WHERE Account.Name = :accountName LIMIT :pageSize OFFSET :offset];
        return contacts;
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalContacts(String accountName){
        Integer totalContacts = [SELECT Count() FROM Contact WHERE Account.Name = :accountName WITH SECURITY_ENFORCED];
        System.debug('Total Contacts: ' + totalContacts);
        return totalContacts;
    }
}

public with sharing class WizardAuraController { 
    @AuraEnabled
    public static String createAccount(Account account){
        try {
            if(account.Name != null) {
                insert account;
                System.debug('Account inserted :'+account); 
                return(account.Id);  
            }
            return null;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }
    @AuraEnabled
    public static String createContact(Contact contact){
        try {
            System.debug('Contact inserted :'+contact); 
            if(contact.LastName != null) {
                insert contact;
                return contact.id;
            }
            return null;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }
    @AuraEnabled
    public static String createEvent(Event event){
        try {
            insert event;
            System.debug('Event inserted :'+event); 
            return event.Id;
            
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            // throw new AuraHandledException(e.getMessage());
            return null;
        }
    }
}
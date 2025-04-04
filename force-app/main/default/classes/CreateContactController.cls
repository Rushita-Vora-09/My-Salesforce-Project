public with sharing class CreateContactController {
    @AuraEnabled
    public static Contact saveContact(Contact contactRec) {
        if (contactRec == null || String.isEmpty(contactRec.LastName)) {
            // throw new AuraHandledException('Error: Last Name is required.');
            System.debug('Error: Last Name is required.');
            return null;
        }
        try {
            insert contactRec;
            return contactRec;
        } catch (Exception e) {
            System.debug('Error in Contact Insertion: ' + e.getMessage());
            // throw new AuraHandledException('Error creating contact: ' + e.getMessage());
            return null;
        }
    }
}
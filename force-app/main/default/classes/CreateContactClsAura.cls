public with sharing class CreateContactClsAura {
    @AuraEnabled
    public static string createContactAura(Contact con){
        try {
            System.debug('con: '+con);
            insert con;
            return con.Name;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
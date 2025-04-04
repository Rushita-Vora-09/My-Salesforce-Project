public with sharing class GetAllAccountsForLWC 
{
    // create wrapper class for return related data with account and related data
    public class AccountWrapperClass
    {
        // account object
        // related contact list
        @AuraEnabled
        public List<Contact> conList;
        // related opportunity list
        @AuraEnabled
        public List<Opportunity> oppList;


        public AccountWrapperClass(List<Contact> conList, List<Opportunity> oppList)
        {
            this.conList = conList;
            this.oppList = oppList;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAllAccounts()
    {
        if (Schema.sObjectType.Account.isAccessible()) {
            return [SELECT Id, Name FROM Account ORDER BY Name];
        } else {
            throw new AuraHandledException('You do not have permission to access Account records.');
        }
    }

    // fetchRelatedData function to get related contact and opportunity 
    @AuraEnabled(cacheable=true)
    public static AccountWrapperClass fetchRelatedData(Id accId) 
    {
        // use wrapper class to return required data
        List<Contact> conList = new List<Contact>();
        if (Schema.sObjectType.Contact.isAccessible()) {
            conList = [SELECT Id, Name, Email, Phone, AccountId FROM Contact WHERE AccountId =:accId];
        } else {
            throw new AuraHandledException('You do not have permission to access Contact records.');
        }
        List<Opportunity> oppList = new List<Opportunity>();
        if (Schema.sObjectType.Opportunity.isAccessible()) {
            oppList = [SELECT Id, Name, Type, StageName, Amount, CloseDate, AccountId FROM Opportunity WHERE AccountId =: accId];
        } else {
            throw new AuraHandledException('You do not have permission to access Opportunity records.');
        }
        AccountWrapperClass accWrapper = new AccountWrapperClass(conList, oppList);
        System.debug('accWrapper: '+accWrapper);
        return accWrapper;
    }
}
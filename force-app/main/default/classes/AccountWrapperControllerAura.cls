public with sharing class AccountWrapperControllerAura{
    // Wrapper Class 
    public class AccountWrapperClass {
        @AuraEnabled public Account acc;
        @AuraEnabled public List<Contact> conList;
        @AuraEnabled public List<Opportunity> oppList;

        public AccountWrapperClass(Account acc, List<Contact> conList, List<Opportunity> oppList){
            this.acc = acc;
            this.conList = conList;
            this.oppList = oppList;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<AccountWrapperClass> getAccConOpp(){
        List<AccountWrapperClass> wrapperList = new List<AccountWrapperClass>();

        List<Account> accList  = [SELECT Id, Name FROM Account 
        WHERE Id IN (SELECT AccountId FROM Contact) 
        AND Id IN (SELECT AccountId FROM Opportunity)];

        for(Account acc : accList){
            List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE AccountId =:acc.Id];
            List<Opportunity> opportunities = [SELECT Id, Name, StageName, Amount FROM Opportunity WHERE AccountId =:acc.Id];

            wrapperList.add(new AccountWrapperClass(acc, contacts, opportunities));
        }

        return wrapperList;
    }
}

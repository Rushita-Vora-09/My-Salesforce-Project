@isTest
public with sharing class QueueableApexExTest {
    @TestSetup
    static void setup() {
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<100;i++) {
            accList.add(new Account(Name='Mr. '+i));
        }
        insert accList;
    }
    @isTest
    private static void testQueueable() {
        String rating='Hot';
        List<Account> accList = [SELECT Id FROM Account WHERE Name LIKE 'Mr.%'];
        QueueableApexEx queue = new QueueableApexEx(accList,rating);

        Test.startTest();
        System.enqueueJob(queue);
        Test.stopTest();

        System.assertEquals(100,[SELECT Id FROM Account WHERE rating = 'Hot'].size(),'Rating should be Hot !');
    }
}
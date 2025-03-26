public with sharing class QueueableApexEx implements Queueable {

    List<Account> accList = new List<Account>();
    String rating ;

    public QueueableApexEx(List<Account> accountList, String rating) {
        this.accList = accountList;
        this.rating = rating;
    }
    public void execute(QueueableContext context) {
        for(Account acc : accList) {
            acc.Rating = rating;
        }
        if (!accList.isEmpty()) {
            update accList;
        }
    }
}

// Run Queueable Apex :

// List<Account> accList = [SELECT Id FROM Account WHERE Name Like '%Mr.%'];
// QueueableApexEx queue = new QueueableApexEx(accList,'Hot');
// Id jobId = System.enqueueJob(queue);
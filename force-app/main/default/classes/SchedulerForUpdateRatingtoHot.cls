public with sharing class SchedulerForUpdateRatingtoHot implements Schedulable {

    public void execute(SchedulableContext ctx) {
        System.debug('Scheduled For Create Opportunity');
        List<Account> updateratingList = new List<Account>();
        List<Account> opps = [SELECT Id, Name, Rating FROM Account WITH SECURITY_ENFORCED];

        for(Account opp : opps) {
            updateratingList.add(new Account(Id = opp.Id, Rating = 'Hot'));
        }

        try {
            insert opps;
        } catch (DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }

    }
}
// SchedulerForUpdateRatingtoHot updateRating = new SchedulerForUpdateRatingtoHot();
// // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
// String sch = '0 0 0 ? * 1-2';
// String jobID = System.schedule('Update Rating To Hot', sch, updateRating);
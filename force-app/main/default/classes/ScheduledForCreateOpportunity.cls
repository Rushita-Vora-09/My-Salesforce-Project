public with sharing class ScheduledForCreateOpportunity implements Schedulable {

    public void execute(SchedulableContext ctx) {
        System.debug('Scheduled For Create Opportunity');
        Integer count = 1;
        List<Opportunity> opps = new List<Opportunity>();

        do {
            Opportunity opp = new Opportunity(Name = 'Opp' + count, StageName = 'Prospecting', CloseDate = Date.today().addDays(30));
            opps.add(opp);
            count++;
        } while (count <= 10);

        try {
            insert opps;
        } catch (DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }

    }
}
// ScheduledForCreateOpportunity reminder = new ScheduledForCreateOpportunity();
// // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
// String sch = '0 30 11 * * ?';
// String jobID = System.schedule('Remind Opp Owners', sch, reminder);
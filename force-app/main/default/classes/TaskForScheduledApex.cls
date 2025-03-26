public with sharing class TaskForScheduledApex {
    public TaskForScheduledApex() {
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
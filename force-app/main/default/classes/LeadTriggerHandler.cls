public class LeadTriggerHandler {
    public static void updateLeadRating(List<Lead> newLeads) {
        for (Lead l : newLeads) {
            l.Rating = 'Hot';
        }
    } 
}

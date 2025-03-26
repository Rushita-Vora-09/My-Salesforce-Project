trigger LeadTrigger on Lead (before insert) {
    LeadTriggerHandler.updateLeadRating(Trigger.new);
} 
public with sharing class AllApexContext {
    public static void allApexContext(Trigger.OperationType  operationType) {
        switch on Trigger.operationType{
            when BEFORE_INSERT {
                system.debug('Before Inserted');
            }
            when BEFORE_UPDATE {
                system.debug('Before Updated');
            }
            when BEFORE_DELETE {
                system.debug('Before Deleteed'); 
            }       
            when AFTER_INSERT {
                system.debug('After Inserted');
            }   
            when AFTER_UPDATE {
                system.debug('After Updated');
            }
            when AFTER_DELETE {
                system.debug('After Deleted');
            }
            when AFTER_UNDELETE {
                system.debug('After Undeleted');
            }   
            when else {
                system.debug('Do Nothing');
            }
        }
    }
}
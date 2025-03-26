({
    handleNext : function(component, event, helper) {
        var currentStep = component.get('v.currentStep');
        if(currentStep == 1){
            helper.saveAccount(component, event, helper);
            component.set('v.currentStep', currentStep+1);
        } else if(currentStep == 2) {
            helper.saveContact(component, event, helper);
            component.find('nextButton').set("v.label", 'Save');
            component.set('v.currentStep', currentStep+1);
        } else if(currentStep == 3) { 
            // hange label of id = nextButton
            helper.saveEvent(component, event, helper);
        }
        // refrash page
    },

    handlePrevious : function(component, event, helper) {
        console.log('handlePrevious');
        component.find('nextButton').set("v.label", 'Next');

        var currentStep = component.get('v.currentStep');
        component.set('v.currentStep', currentStep-1);

    }
})
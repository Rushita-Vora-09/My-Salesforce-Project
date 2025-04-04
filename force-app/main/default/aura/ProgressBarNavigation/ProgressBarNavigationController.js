({
    handleNext: function(component, event, helper) {
        var currentStep = component.get("v.currentStep");
        var totalSteps = component.get("v.totalSteps");
        
        if (currentStep < totalSteps) {
            component.set("v.currentStep", currentStep + 1);
        }
    },

    handlePrevious: function(component, event, helper) {
        var currentStep = component.get("v.currentStep");

        if (currentStep > 1) {
            component.set("v.currentStep", currentStep - 1);
        }
    }
})
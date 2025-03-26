({

    fetchAccounts: function(component, event, helper) {
        var action = component.get("c.getAccConOpp");
        console.log("action: " + action);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accountData", response.getReturnValue());
            } else {
                console.error("Error fetching accounts: " + response.getError());
            }
            component.set("v.isLoading", false);
        })
        $A.enqueueAction(action);
    }
})
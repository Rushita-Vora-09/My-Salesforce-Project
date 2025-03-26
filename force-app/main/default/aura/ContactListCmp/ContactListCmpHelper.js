({ 
    doInitHelper: function(component, event, helper) {        
        var action = component.get("c.getAllContacts");
        action.setParams({
            pageNumber: component.get("v.pageNumber"),
        pageSize: component.get("v.pageSize")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
                this.fetchAllTotalContacts(component);
            } else {
                console.error("Error fetching contacts: ", response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    fetchAllTotalContacts : function(component) {
        var action = component.get("c.getAllContactTotal");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.totalContacts", response.getReturnValue());
            }
        });
        component.set("v.fromContact", 1);
        component.set("v.toContact", component.get("v.pageSize"));
        $A.enqueueAction(action);

    },   

    fetchContacts: function(component) {
        var action = component.get("c.getContacts");
        action.setParams({
            accountName: component.get("v.accountName"),
            pageNumber: component.get("v.pageNumber"),
            pageSize: component.get("v.pageSize")
        });

        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
                this.fetchTotalContacts(component);
            } else {
                console.error("Error fetching contacts: ", response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    fetchTotalContacts: function(component) {
        var action = component.get("c.getTotalContacts");
        action.setParams({ 
            accountName: component.get("v.accountName"),
        });
    
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var totalContacts = response.getReturnValue();
                component.set("v.totalContacts", totalContacts);
                component.set("v.totalPages", Math.ceil(totalContacts / component.get("v.pageSize")));
    
                // Set fromContact and toContact only if pageNumber is 1
                if (component.get("v.pageNumber") === 1) {
                    component.set("v.fromContact", 1);
                    component.set("v.toContact", Math.min(component.get("v.pageSize"), totalContacts));
                }
            } else {
                console.error("Error fetching total contacts: ", response.getError());
            }
        });
    
        $A.enqueueAction(action);
    }
    
});

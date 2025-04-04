({
    searchAccount : function(component,searchAccount, contactList,contactCount) {
        var action = component.get("c.getAccountContact");
        if(component.get("v." + searchAccount)==""){
            component.set("v." + contactList, []);
        }
        else {
            action.setParams({
                accountName: component.get("v." + searchAccount),
            });

            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    var accountContact = response.getReturnValue();
                    component.set("v." + contactList, accountContact);
                    this.setContactCount(component,searchAccount,contactCount);  
                }
                else { 
                    console.error("Error fetching account contact1: " + response.getError());
                }
            });
        }
        $A.enqueueAction(action);
    },

    setContactCount : function(component,searchAccount,contactCount) {
        var action = component.get("c.getContactCount");
        action.setParams({
            accountName: component.get("v." + searchAccount),
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var getContactCounts = response.getReturnValue();
                component.set("v." + contactCount, getContactCounts);
            }
            else { 
                console.error("Error fetching contact count: " + response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    updateContactAccount: function(component, contactId, newAccountName) {
    var action = component.get("c.updateContactAccount");
    action.setParams({
        contactId: contactId,
        newAccountName: newAccountName
    });

    action.setCallback(this, function(response) {
        if (response.getState() === "SUCCESS") {
            console.log("Contact moved successfully!");
            
            // Refresh both account lists after successful update
            $A.getCallback(function() {
                this.searchAccount(component, "account1", "accountContact1", "contactCount1");
                this.searchAccount(component, "account2", "accountContact2", "contactCount2");
            }).bind(this)();
        } else {
            console.error("Error updating contact account: " + response.getError());
        }
    });

    $A.enqueueAction(action);
}

    
})
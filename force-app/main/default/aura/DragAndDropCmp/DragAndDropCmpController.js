({
    handleSearch1: function(component, event, helper) {
        helper.searchAccount(component,"account1","accountContact1","contactCount1");
    },

    handleSearch2 : function(component, event, helper) {
        helper.searchAccount(component,"account2","accountContact2","contactCount2");
    },

    handleDragStart: function(component, event, helper) {
        let contactId = event.currentTarget.id; // Ensure correct ID
        console.log("Dragging Contact ID: " + contactId);
        event.dataTransfer.setData("contactId", contactId);
        component.set("v.contactId", contactId);
    },
    
    allowDrop : function(component, event, helper) {
        event.preventDefault();
    },

    handleDropToAccount1: function(component, event, helper) {
        event.preventDefault();
        
        let contactId = event.dataTransfer.getData("contactId");
        let account = component.get("v.account1"); // Ensure this is an Account object
    
        console.log('Moving Contact ID: ' + contactId + ' to Account : ' + account);
        helper.updateContactAccount(component, contactId, account);
    },
    
    handleDropToAccount2: function(component, event, helper) {
        event.preventDefault();
        
        let contactId = event.dataTransfer.getData("contactId");
        let account = component.get("v.account2"); // Ensure this is an Account object
    
        console.log('Moving Contact ID: ' + contactId + ' to Account : ' + account);
        helper.updateContactAccount(component, contactId, account);
    }
    
})
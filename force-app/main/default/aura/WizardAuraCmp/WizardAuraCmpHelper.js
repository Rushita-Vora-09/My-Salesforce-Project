({
    saveAccount : function(component, event) {
        console.log('saveAccount');
        var accountData = component.get('v.accountData');
        var action = component.get('c.createAccount');
        action.setParams({
            account: accountData
        });
        action.setCallback(this, function(response) {
            console.log(response);
        });
        $A.enqueueAction(action);          
    },

    saveContact : function(component, event) {
        if(component.get('v.accountData').Name == null) {
            console.log('Related Account is empty');
            alert('Account is empty, please go to previous and create an account before proceed to next step');
            return
        }
        component.set('v.contactDate.AccountId', component.get('v.accountData').Id);
        console.log('saveConatact');
        var contactData = component.get('v.contactData');
        var action = component.get('c.createContact');
        action.setParams({
            contact: contactData
        });
        action.setCallback(this, function(response) {
            console.log(response);
        });
        $A.enqueueAction(action);
    },

    saveEvent : function(component, event) {
        if(component.get('v.contactData').LastName == null) {
            console.log('Related Contact is empty');
            alert('Contact is empty, please go to previous and create a contact before proceed to next step');
            return;
        }
        console.log('saveEvent');
        component.set('v.eventData.Subject','Wizard Task');

        component.set('v.eventData.WhatId', component.get('v.accountData').Id);
        component.set('v.eventData.WhoId', component.get('v.contactData').Id);

        var eventData = component.get('v.eventData');
        var action = component.get('c.createEvent');
        action.setParams({
            event: eventData
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            alert('New Event is Created !');
        });
        this.refreshPage();
        $A.enqueueAction(action);
    },

    refreshPage : function() {
        window.location.reload();
    }
})
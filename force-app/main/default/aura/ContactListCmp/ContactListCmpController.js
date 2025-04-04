({
    doInit: function(component, event, helper) {
        helper.doInitHelper(component);
    },

    handleSearch: function(component, event, helper) {
        component.set("v.pageNumber", 1);
        helper.fetchContacts(component);
    },

    previousPage: function(component, event, helper) {
        var page = component.get("v.pageNumber");
    
        if (page > 1) {
            // First, decrement pageNumber
            var newPage = page - 1;
            component.set("v.pageNumber", newPage);
    
            // Now, calculate fromContact and toContact based on the updated pageNumber
            var pageSize = parseInt(component.get("v.pageSize"));
            var fromContact = ((newPage - 1) * pageSize) + 1;
            var toContact = Math.min(fromContact + pageSize - 1, component.get("v.totalContacts"));
    
            component.set("v.fromContact", Math.max(fromContact, 1));
            component.set("v.toContact", toContact);
    
            helper.fetchContacts(component);
        }
    },    
    

    nextPage: function(component, event, helper) {
        var page = component.get("v.pageNumber");
        component.set("v.pageNumber", page + 1);
        var fromContact = ((component.get("v.pageNumber") - 1) * parseInt(component.get("v.pageSize"))) + 1;
        component.set("v.fromContact", fromContact );
        var toContact = Math.min(parseInt(component.get("v.fromContact")) + parseInt(component.get("v.pageSize")) - 1, parseInt(component.get("v.totalContacts")));
        component.set("v.toContact", toContact );

        helper.fetchContacts(component);
    },

    handlePageSize: function(component, event, helper) {
        var pageSize = parseInt(event.target.value);
        component.set("v.pageSize", pageSize);
        component.set("v.pageNumber", 1);
    
        // Set fromContact and toContact only here to prevent duplicate updates
        var totalContacts = parseInt(component.get("v.totalContacts"));
        component.set("v.fromContact", 1);
        component.set("v.toContact", Math.min(pageSize, totalContacts));
    
        helper.fetchContacts(component);
    }    
    
});
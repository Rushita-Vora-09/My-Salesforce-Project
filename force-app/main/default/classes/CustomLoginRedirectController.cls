public with sharing class CustomLoginRedirectController {
    public PageReference redirectToCustomLogin() {
        // Replace 'customlogin' with the URL of your custom page
        PageReference customLoginPage = new PageReference('/Select_Profile__c');
        customLoginPage.setRedirect(true);
        return customLoginPage;
    }
}
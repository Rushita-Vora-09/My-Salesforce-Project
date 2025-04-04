@isTest
private class TestSiteRegisterController {
    @isTest
    static void testSiteRegisterController() {
        Test.startTest();
        
        // Initialize Controller
        SiteRegisterController controller = new SiteRegisterController();
        
        // Set test values
        controller.username = 'testuser@example.com';
        controller.email = 'testuser@example.com';
        controller.password = 'TestPass123';
        controller.confirmPassword = 'TestPass123';
        controller.communityNickname = 'testuser';

        // Test registerUser() - Successful Registration
        PageReference result = controller.registerUser();
        System.assertEquals(null, result, 'Expected null as Site.createPortalUser is not actually executed in test.');

        // Test registerUser() - Password Mismatch
        controller.password = 'TestPass123';
        controller.confirmPassword = 'WrongPass123';
        result = controller.registerUser();
        System.assertEquals(null, result, 'Should return null due to password mismatch.');

        Test.stopTest();
    }
}
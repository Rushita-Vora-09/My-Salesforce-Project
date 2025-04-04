@isTest
private class TestAuthController {
    @isTest
    static void testAuthController() {
        AuthController auth = new AuthController();

        // Test Registration
        auth.username = 'testUser';
        auth.password = 'TestPass123';
        auth.confirmPassword = 'TestPass123';
        auth.register();

        // Test Login
        auth.username = 'testUser';
        auth.password = 'TestPass123';
        auth.login();

        // Test Forgot Password
        auth.email = 'testUser';
        auth.forgotPassword();

        // Test Mode Switching (Covers switchMode(String newMode))
        auth.switchMode('register');
        System.assertEquals('register', auth.mode, 'Mode should be register');

        // Test switchMode() (Covers switchMode() with ApexPages parameter)
        Test.startTest();
        PageReference pageRef = new PageReference('/apex/dummyPage');
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('newMode', 'login');
        auth.switchMode();
        Test.stopTest();

        System.assertEquals('login', auth.mode, 'Mode should be login');
    }
}
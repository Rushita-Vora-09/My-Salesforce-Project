@isTest
private class TestAuth {
    @isTest
    static void testAuthController() {
        // Create test Contact
        Contact testContact = new Contact(
            LastName = 'TestUser',
            Email = 'testuser@example.com',
            Password__c = 'Password1'
        );
        insert testContact;

        // Create a standard controller instance
        ApexPages.StandardController stdController = new ApexPages.StandardController(testContact);
        Auth authController = new Auth(stdController);

        // Test Initial Values
        System.assert(authController.showLogin, 'Login should be shown initially');
        System.assert(!authController.showRegistration, 'Registration should not be shown initially');
        System.assert(!authController.showForgotPassword, 'Forgot Password should not be shown initially');

        // Test login with correct credentials
        authController.email = 'testuser@example.com';
        authController.password = 'Password1';
        authController.loginDetail();
        System.assertEquals(testContact.Email, authController.email, 'Email should match');
        
        // Test login with incorrect password
        authController.password = 'WrongPassword';
        authController.loginDetail();

        // Test login with non-existing email
        authController.email = 'notfound@example.com';
        authController.loginDetail();

        // Test showing registration form
        authController.showRegistrationForm();
        System.assert(authController.showRegistration, 'Registration form should be shown');
        System.assert(!authController.showLogin, 'Login form should be hidden');

        // Test user registration (Valid Password)
        authController.newUsername = 'NewUser';
        authController.newEmail = 'newuser@example.com';
        authController.newPassword = 'ValidPass1';
        authController.registerUser();
        
        // Check if new user was inserted
        Contact registeredContact = [SELECT Email FROM Contact WHERE Email = 'newuser@example.com' LIMIT 1];
        System.assertEquals('newuser@example.com', registeredContact.Email, 'New user should be registered');

        // Test user registration (Invalid Password)
        authController.newPassword = 'weak';
        authController.registerUser();

        // Test showing login form
        authController.showLoginForm();
        System.assert(authController.showLogin, 'Login form should be shown');

        // Test showing forgot password page
        authController.showForgotPasswordPage();
        System.assert(authController.showForgotPassword, 'Forgot password page should be shown');

        // Test sending reset password email (Valid Email)
        authController.forgotPasswordEmail = 'testuser@example.com';
        authController.sendResetPasswordEmail();

        // Test sending reset password email (Invalid Email)
        authController.forgotPasswordEmail = 'notfound@example.com';
        authController.sendResetPasswordEmail();
    }
}
public class AuthController {
    
    public String username { get; set; }
    public String password { get; set; }
    public String email { get; set; }
    public String confirmPassword { get; set; }
    public String message { get; set; }
    public String mode { get; set; }
    
    // Temporary storage for registered users
    public static Map<String, String> registeredUsers = new Map<String, String>();

    public AuthController() {
        mode = 'login'; // Default mode
    }

    // Login Method
    public void login() {
        if (registeredUsers.containsKey(username) && registeredUsers.get(username) == password) {
            message = 'Login Successful!';
        } else {
            message = 'Invalid Credentials!';
        }
    }

    // Register Method
    public void register() {
        if (password == confirmPassword) {
            registeredUsers.put(username, password);
            message = 'Registration Successful! Please Login.';
            mode = 'login'; // Switch to login mode
        } else {
            message = 'Passwords do not match!';
        }
    }

    // Forgot Password Method
    public void forgotPassword() {
        if (registeredUsers.containsKey(email)) {
            String newPassword = generateRandomPassword();
            registeredUsers.put(email, newPassword);
            sendEmail(email, newPassword);
            message = 'New password sent to your email!';
        } else {
            message = 'Email not found!';
        }
    }

    // Generate Random Password
    private String generateRandomPassword() {
        return 'NewPass' + String.valueOf(Math.random()).substring(2, 6);
    }

    // Send Email
    private void sendEmail(String toEmail, String newPassword) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { toEmail });
        mail.setSubject('Password Reset');
        mail.setPlainTextBody('Your new password is: ' + newPassword);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

    // Method to switch between modes
    public void switchMode(String newMode) {
        mode = newMode;
        message = '';
    }
    
    public void switchMode() {
    String newMode = ApexPages.currentPage().getParameters().get('newMode');
    if (newMode != null) {
        mode = newMode;
    }
    message = ''; // Clear previous messages
}

}
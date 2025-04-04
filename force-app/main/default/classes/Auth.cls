public class Auth {
    public String email { get; set; }
    public String password { get; set; }
    public String newUsername { get; set; }
    public String newEmail { get; set; }
    public String newPassword { get; set; }
    public String forgotPasswordEmail { get; set; }
    public Boolean showLogin { get; set; }
    public Boolean showRegistration { get; set; }
    public Boolean showForgotPassword { get; set; }
    public Contact con;

    public Auth(ApexPages.StandardController stdController) {
        this.con = (Contact)stdController.getRecord();
        showLogin = true;
        showRegistration = false; 
        showForgotPassword = false; 
    }

    public PageReference loginDetail() {
        try {
            List<Contact> contacts = [SELECT Id, LastName, Email, Password__c FROM Contact WHERE Email = :email LIMIT 1];
            if (!contacts.isEmpty()) {
                con = contacts[0];
                if (con.Password__c == password) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Login successful! Welcome'+ con.LastName));
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Login failed. Please check your email, or password.'));
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No contact found with the provided email.'));
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred: ' + e.getMessage()));
        }
        return null;
    }

    public PageReference showLoginForm() {
        showLogin = true;
        showRegistration = false;
        showForgotPassword = false; 
        return null;
    }
    
    public PageReference showRegistrationForm() {
        showRegistration = true;
        showForgotPassword = false;
        showLogin = false;
        return null;
    }

    public PageReference registerUser() {
        
        try {
            if((newPassword.length() >= 8)&&(newPassword.containsAny('0123456789') && newPassword.containsAny('ABCDEFGHIJKLMNOPQRSTUVWXYZ') && newPassword.containsAny('abcdefghijklmnopqrstuvwxyz'))) {
                Contact newContact = new Contact(
                    LastName = newUsername,
                    Email = newEmail,
                    Password__c = newPassword
                );
                insert newContact;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Registration successful!'));
                showLogin = true;
                showRegistration = false;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Password length must greater or equal 8 and must contains One UpperCase, One Lowercase and One Digit.'));
                return null;
        	}
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred during registration: ' + e.getMessage()));
        }
        return null;
        
    }

    public PageReference showForgotPasswordPage() {
        showForgotPassword = true;
        showRegistration = false;
        showLogin = false;
        return null;
    }

    public PageReference sendResetPasswordEmail() {
        try {
            List<Contact> contacts = [SELECT Id, Email, Password__c FROM Contact WHERE Email = :forgotPasswordEmail LIMIT 1];
            if (!contacts.isEmpty()) {
                con = contacts[0];
                // Send email to user
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {con.Email};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Password Reset Request');
                mail.setPlainTextBody('Hello, Your request for reset password is accepted.\n\n Please try this password to login in your account \n\n' + con.Password__c);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'An email has been sent to reset your password.'));
                showForgotPassword = false;
                showLogin = true;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No contact found with the provided email.'));
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while sending the email: ' + e.getMessage()));
        }
        return null;
    }
}
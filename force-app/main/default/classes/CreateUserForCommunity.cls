public without sharing class CreateUserForCommunity {
    // for custom theme get userId for profile
    @AuraEnabled
    public static String getCurrentUserId() {
        return UserInfo.getUserId();
    }

    @AuraEnabled
    public static String getCurrentUserProfileName() {
        return [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
    }
    


    // create teacher user 
    @AuraEnabled
    public static void createUser(String firstName, String lastName, String email,String profileName){
        // get user id by user name
        // User currentUser = [SELECT Id FROM User WHERE UserName = :UserInfo.getUserName() WITH SECURITY_ENFORCED];
        // System.debug(UserInfo.getUserId());
        String role = [SELECT UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()].UserRole.Name;
        System.debug('User Role: ' + role);
        System.debug(UserInfo.getUserRoleId());

        Account act = new Account(
            Name = firstName +' '+ lastName,
            OwnerId = UserInfo.getUserId()
        );
        insert act;

        // create contact
        Contact con = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            AccountId = act.Id
        );
        insert con;

        Profile portalProfile = [SELECT Id FROM Profile WHERE Name=:profileName Limit 1];

        if(portalProfile == null){
            return; 
        }
        User user1 = new User(
            UserName = email + System.now().millisecond(),
            FirstName = firstName,
            LastName = lastName,
            Alias = firstName.charAt(0)+ lastName.substring(0),
            email = email,
            ContactId = con.Id,
            ProfileId = portalProfile.Id,
            EmailEncodingKey = 'UTF-8',
            CommunityNickname = firstName + lastName + System.currentTimeMillis(),
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        
        if (Schema.sObjectType.User.isCreateable()) {
            // insert user1;  // uncomment this line for create user in community
            // System.debug('user1Id: '+user1.Id);
            // System.debug('User '+user1+' Created Successfully.');
            System.setPassword(user1.Id, firstName+lastName+System.now().millisecond());
            sendWelcomeEmail(user1.Id, con.Email);
        } else {
            throw new System.SecurityException('Insufficient permissions to create User records.');
        }
    }

    public static void sendWelcomeEmail(String userId, String email){
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            // user email template - Welcome New Student
            EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Welcome Email ST Portal' WITH SECURITY_ENFORCED];
            mail.setTemplateId(et.Id);
            mail.setTargetObjectId(userId);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            System.debug('sendWelcomeEmail: '+mail);
        }
        catch(Exception e) {
            System.debug('Error: '+e.getMessage());
        }
    }


    @AuraEnabled
    public static String loginUser(String username, String password) {
        try {
            String startUrl = 'https://mvclouds-df-dev-ed.develop.my.site.com/stportal/s/';
            PageReference pageRef = Site.login(username, password, startUrl);
            // System.debug(pageRef);
            
        if(pageRef != null) {
            return pageRef.getUrl();
        } else {
            return 'null';    
        }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static string resetPasswordSendByEmail(String username){
        try {
            // get user id
            Id userId = [SELECT Id, Name, Email FROM User WHERE username =: username].Id;
            System.resetPassword(userId, true);
            return 'success';
            
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Student__c> getStudents(){
        // get all sudents under the current teacher user
        try {
            //get current user contact id
            String conId = [SELECT Id, ContactId FROM User Where Id = :UserInfo.getUserId()].ContactId;
            System.debug('conId: '+conId);
            List<Student__c> students = [SELECT Id, Name, Email__c FROM Student__c WHERE Teacher_Contact__c = :conId WITH SECURITY_ENFORCED];
            System.debug('students: '+students);
            if(students.size() > 0) {
                return students;
            } else {
                return null;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }      
    }

    @AuraEnabled
    public static Student__c getStudentDetail(String recordId){
        // get student detail by id
        try {
            Student__c student = [SELECT Id, Name, Email__c, Age__c, Mobile_no__c, Parent__c,Feedback__c, Teacher_Contact__c FROM Student__c WHERE Id = :recordId];
            System.debug('student: '+student);
            if(student != null) {
                return student;
            } else {
                return null;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void updateStudentFeedback(Id recordId, String feedback) {
        try {
            Student__c student = [SELECT Id, Feedback__c FROM Student__c WHERE Id = :recordId LIMIT 1];
            student.Feedback__c = feedback;
            update student;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to save feedback: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string getSemester1() {
        String conId = [SELECT Id, Name, contactId FROM User WHERE Id = :UserInfo.getUserId()].Id;
        System.debug('contactId: '+conId);
        List<Student__c> student = [SELECT Id, Semester__c FROM Student__c WHERE Teacher_Contact__c = :conId WITH SECURITY_ENFORCED];
        System.debug('student: '+student);
        if(student.size() > 0) {
            return student[0].Semester__c;
        } else {
            return null;
        }
    }   

    @AuraEnabled
    public static string getSemester() {
        String conId = [SELECT Id, Name, ContactId FROM User WHERE Id = :UserInfo.getUserId()].ContactId;
        System.debug('Contact ID: ' + conId);
        
        List<Student__c> students = [SELECT Id, Semester__c FROM Student__c WHERE Teacher_Contact__c = :conId];
        System.debug('Students: ' + students);
        
        if (!students.isEmpty()) {
            return students[0].Semester__c;
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static string getUrl() {
        String communityUrl = URL.getOrgDomainUrl().toExternalForm(); // Get the base domain
        System.debug('Community URL: ' + communityUrl);

        // If the code runs within a community, you can fetch the context using `Network`
        String networkId = Network.getNetworkId();
        String fullCommunityUrl = URL.getOrgDomainUrl().toExternalForm() + '/s/'    ;
        System.debug('Full Community URL: ' + fullCommunityUrl);
        
        return Network.getLoginUrl(Network.getNetworkId());
    }

}
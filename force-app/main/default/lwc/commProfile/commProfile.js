import { LightningElement, api} from 'lwc';
import getCurrentUserId from '@salesforce/apex/CreateUserForCommunity.getCurrentUserId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USER_NAME from '@salesforce/schema/User.Name';
import USER_EMAIL from '@salesforce/schema/User.Email';
import USER_PHONE from '@salesforce/schema/User.Phone';
import USER_ALIAS from '@salesforce/schema/User.Alias';
import USER_TITLE from '@salesforce/schema/User.Title';
import USER_COMPANY from '@salesforce/schema/User.CompanyName';
import USER_PROFILE from '@salesforce/schema/User.ProfileId';
import USER_ACTIVE from '@salesforce/schema/User.IsActive';
import USER_TIMEZONE from '@salesforce/schema/User.TimeZoneSidKey';
import USER_LOCALE from '@salesforce/schema/User.LocaleSidKey';
import USER_LANGUAGE from '@salesforce/schema/User.LanguageLocaleKey';
import USER_ADDRESS from '@salesforce/schema/User.Street';
import USER_DEPARTMENT from '@salesforce/schema/User.Department';
import USER_DIVISION from '@salesforce/schema/User.Division';
import USER_MANAGER from '@salesforce/schema/User.ManagerId';
import USER_EMPLOYEE_NUMBER from '@salesforce/schema/User.EmployeeNumber';
import USER_CREATED_DATE from '@salesforce/schema/User.CreatedDate';
import USER_LAST_LOGIN from '@salesforce/schema/User.LastLoginDate';
import USER_TYPE from '@salesforce/schema/User.UserType'; 


export default class CommProfile extends LightningElement {
    // User fields
    nameField = USER_NAME;
    emailField = USER_EMAIL;
    phoneField = USER_PHONE;
    aliasField = USER_ALIAS;
    titleField = USER_TITLE;
    companyField = USER_COMPANY;
    profileField = USER_PROFILE;
    activeField = USER_ACTIVE;
    timeZoneField = USER_TIMEZONE;
    localeField = USER_LOCALE;
    languageField = USER_LANGUAGE;
    addressField = USER_ADDRESS;
    departmentField = USER_DEPARTMENT;
    divisionField = USER_DIVISION;
    managerField = USER_MANAGER;
    employeeNumberField = USER_EMPLOYEE_NUMBER;
    createdDateField = USER_CREATED_DATE;
    lastLoginField = USER_LAST_LOGIN;
    userTypeField = USER_TYPE; 
    
    // Flexipage provides recordId and objectApiName
    @api recordId;
    @api objectApiName;
    // Display the record data
    @api get record() {
        return {
            objectApiName: this.objectApiName,
            recordId: this.recordId
        };
    }

    connectedCallback() {
        this.objectApiName = 'User';
        // call apex method getCurrentUserId
        getCurrentUserId().then(result => {
            this.recordId = result;
        }).catch(error => {
            console.log(error);
        });
        
    }
    handleSuccess() {
        const event = new ShowToastEvent({
            title: "Success",
            message: "Profile Updated Successfully!",
            variant: "success",
        });
        this.dispatchEvent(event);
    }
}
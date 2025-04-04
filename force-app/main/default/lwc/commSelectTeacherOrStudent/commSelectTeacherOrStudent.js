import { LightningElement, track } from 'lwc'; 
import createUser from '@salesforce/apex/CreateUserForCommunity.createUser'
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from "lightning/refresh";


export default class CommSelectTeacherOrStudent extends NavigationMixin(LightningElement) {
    value = '';
    @track displayOptionPage = true;
    @track teacherRegisreation = false;
    @track studentRegisreation = false;
    profile = '';
    @track firstName = '';
    @track lastName = '';  
    @track email = '';

    get options() {
        return [
            { label: 'Teacher', value: 'Teacher' },
            { label: 'Student', value: 'Student' },
        ];
    }
    get displayOption() {
        return this.displayOptionPage;
    }
    get displayTeacherRegistration() {
        return this.teacherRegisreation;
    }
    get displayStudentRegistration() {
        return this.studentRegisreation;
    }

    handleSelectProfile(event) {
        this.value = event.detail.value;
        // this.navigateToProfile(profile);
    }
    handleNext() {
        console.log(this.value);
        if (this.value == 'Teacher') {
            this.displayOptionPage = false;
            this.teacherRegisreation = true;
            this.profile = 'Teacher Community';
        }
        else if(this.value == 'Student'){
            this.displayOptionPage = false;
            this.studentRegisreation = true;
            this.profile = 'Student Community';
        }
        else {
            alert('Please select your profile');
        }
    }

    // handle form data

    handleFirstName(event) {
        this.firstName = event.target.value;
    }

    handleLastName(event) {
        this.lastName = event.target.value;
    }

    handleEmail(event) {
        this.email = event.target.value;
    }

    handleCreateUser() {
        // call create user method from apex class
        createUser({firstName: this.firstName, lastName: this.lastName, Email: this.email, profileName: this.profile}) 
        .then(result => {
            console.log(result);    
            // displatch toast
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'User Created Successfully',
                variant: 'success',
            }));
            this.dispatchEvent(new RefreshEvent());
            this.firstName = '';
            this.lastName = '';
            this.email = '';
            // this.navigateToCommunity();
        })
        .catch(error => {
            // this.dispatchEvent(new ShowToastEvent({
            //     title: 'Error',
            //     message: 'Failed to create user. ' + error.body.message,
            //     variant: 'error',
            // }));
            console.log(error);
        });
    }

    
    // redirect page in community
    // navigateToRegistrationPage()  {
    //     this[NavigationMixin.Navigate]({
    //         type: 'comm__namedPage',
    //         attributes: {
    //             apiName: this.value+'Registration_Page'
    //         },
    //         // state: {
    //         //     pageName: 'Registration_Page',
    //         // },
    //     });
    // }
}
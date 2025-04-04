import { LightningElement, track } from 'lwc';
import resetPasswordSendByEmail from '@salesforce/apex/CreateUserForCommunity.resetPasswordSendByEmail';
import { NavigationMixin } from 'lightning/navigation';

export default class CommResetPassword extends NavigationMixin(LightningElement) {
    @track username = '';
    @track errorMessage = '';
    @track displayResetPassword = true;
    @track successPage = false;


    get displayResetPasswordPage(){
        return this.displayResetPassword;
    }

    get successPageDisplay(){
        return this.successPage;
    }

    handleUserName(event) {
        this.username = event.target.value;
    }

    handleResetPw() {
        console.log(this.username);
        if (this.username === ''){
            this.errorMessage = 'Please enter Username';
            return;
        }
        resetPasswordSendByEmail({ username: this.username })
            .then(result => {
                if (result === 'success'){
                    console.log('Reset Password Success');
                    // window.location.href = result;
                    this.displayResetPassword = false;
                    this.successPage = true;
                    // this.handleCancle();
                }
                else {
                    this.errorMessage = 'Invalid UserName. Please try again.';
                    console.log('Error: ' + result);
                }   
            })
            .catch(error => {
                this.errorMessage = 'An error occurred. Please contact support.';   
            });
    }

    handleCancle(){
        this[NavigationMixin.GenerateUrl]({
            type: "standard__webPage",
            attributes: {
                url: "https://mvclouds-df-dev-ed.develop.my.site.com/stportal/s"
            },
            }).then((generatedUrl) => {
            window.open(generatedUrl);
        });
    }
}
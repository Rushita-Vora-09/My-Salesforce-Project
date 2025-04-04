import { LightningElement, track } from 'lwc';
import resetPasswordSendByEmail from '@salesforce/apex/CreateUserForCommunity.resetPasswordSendByEmail';
import { NavigationMixin } from 'lightning/navigation';

export default class CommForgotPassword extends NavigationMixin(LightningElement) {
    @track username = '';
    @track errorMessage = '';
    @track displayForgotPassword = true;
    @track successPage = false;


    get displayForgotPasswordPage(){
        return this.displayForgotPassword;
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
                    this.displayForgotPassword = false;
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
                url: "/stportal/s/login"
            },
            }).then((generatedUrl) => {
            window.open(generatedUrl);
        });
    }
}
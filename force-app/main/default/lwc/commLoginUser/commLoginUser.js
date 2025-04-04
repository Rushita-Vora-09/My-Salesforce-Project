import { LightningElement, track } from 'lwc';
import loginUser from '@salesforce/apex/CreateUserForCommunity.loginUser';
import { NavigationMixin } from 'lightning/navigation';

export default class CustomLogin extends NavigationMixin(LightningElement) {
    @track username = '';
    @track password = '';
    @track errorMessage = '';

    handleUserName(event) {
        this.username = event.target.value;
    }

    handlePass(event) {
        this.password = event.target.value;
    }

    handleLogin() {
        console.log('username: '+this.username);
        console.log('password: '+this.password);
        console.log('Login');
        loginUser({ username: this.username, password: this.password })
            .then(result => {
                if (result.indexOf('http') > -1){
                    console.log('Login Success');
                    window.location.href = result;
                }
                else {
                     this.errorMessage = 'Invalid credentials. Please try again.';
                     console.log('Error: ' + result);
                }
            })
            .catch(error => {
                this.errorMessage = 'An error occurred. Please contact support.';
                console.error(error);
            });
    }

    handleForgotPassword() {
        this[NavigationMixin.GenerateUrl]({
            type: "standard__webPage",
            attributes: {
              url: "/stportal/s/login/ForgotPassword",
              isNavTabPersistenceDisabled : true,
           },
         }).then((generatedUrl) => {
         window.open(generatedUrl);
      });
    }
}

import { LightningElement } from 'lwc';
import getUrl from '@salesforce/apex/CreateUserForCommunity.getUrl';


export default class CommGetUrlInApex extends LightningElement {
    url='';
    connectedCallback() {
        // In your Lightning Component's JavaScript controller
        let currentUrl = window.location.href;
        console.log('Current Community Page URL: ', currentUrl);
        
        getUrl()
            .then(result => {
                this.url = result;
                console.log('URL:', this.url);
            }).catch(error => {
                console.error('Error:', error);
            });
    }
}
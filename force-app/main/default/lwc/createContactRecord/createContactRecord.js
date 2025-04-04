import { LightningElement, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRST_NAME from '@salesforce/schema/Contact.FirstName';
import LAST_NAME from '@salesforce/schema/Contact.LastName';
import EMAIL from '@salesforce/schema/Contact.Email';
import PHONE_NUMBER from '@salesforce/schema/Contact.Phone';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 


export default class CreateContact extends LightningElement {

    firstName = '';
    lastName = '';
    email = '';
    phoneNumber = '';

    handleFirstName(event) {
        this.firstName = event.target.value;
    }
    handleLastName(event) {
        this.lastName = event.target.value;
    }
    handleEmail(event) {
        this.email = event.target.value;
    }
    handlephoneNumber(event) {
        this.phoneNumber = event.target.value;
    }
    handleSave() {
        const fields = {};
        fields[FIRST_NAME.fieldApiName] = this.firstName;
        fields[LAST_NAME.fieldApiName] = this.lastName;
        fields[EMAIL.fieldApiName] = this.email;
        fields[PHONE_NUMBER.fieldApiName] = this.phoneNumber;
        const recordInput = { apiName: CONTACT_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then((contact) => {
                // alert('Success');
                const evt = new ShowToastEvent({

                    title: 'Success!',
                
                    message: contact.id + ' Record Created successfully.',
                
                    variant: 'success' // Options: 'success', 'error', 'warning', 'info'
                
                  });
                
                  this.dispatchEvent(evt);
            })
            .catch(error => {
                console.log('error: ',error);
                alert('Error');
            });
    }
}
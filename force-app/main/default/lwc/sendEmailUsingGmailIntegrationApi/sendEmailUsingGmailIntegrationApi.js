import { LightningElement, track, api, wire} from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import Email_FIELD from '@salesforce/schema/Contact.Email';
import sendEmail from '@salesforce/apex/SendEmailUsingGmailIntegrationApiApex.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class SendEmailUsingGmailIntegrationApi extends LightningElement {
    @track subject;
    @track emailBody;
    @api recordId;
    email;
    
    @wire(getRecord, { recordId:'$recordId', fields: Email_FIELD })
    loadFields({error, data}){
        if(error){
            alert('Error loading record');
        }else if(data){
            this.email = getFieldValue(data, Email_FIELD);
            console.log('email '+this.email);
        }
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
        console.log(this.subject);
    }

    handleChangeDraft(event) {
        this.emailBody = event.target.value;
        console.log(this.emailBody);
    }

    handleSendEmail() {
        if(this.subject === undefined || this.subject === null || this.subject === ''){
            alert('Subject is required');
            return; 
        }
        if(this.emailBody === undefined || this.emailBody === null || this.emailBody === ''){
            alert('Email body is required');
            return;
        }
        console.log('handleSendEmail is called');
        console.log('recordId:', this.recordId);
        let emailId = this.email.toString();
        console.log('emailString:', emailId);
            
        if (emailId.length === 0) {
            alert("No valid email addresses found.");
            return;
        }
    
        sendEmail({ subject: this.subject, body: this.emailBody, emailId: emailId })
            .then(() => {
                this.toastSendMail();
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                console.error('Error sending email:', error);
            });
    }

    // display toast for successfully send mail 
    toastSendMail() {
        const event = new ShowToastEvent({
            title: 'Email sent successfully!',
            variant: 'success',
            message: 'Email sent successfully to the selected records! '
        });
        this.dispatchEvent(event);
    }
    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
        
}
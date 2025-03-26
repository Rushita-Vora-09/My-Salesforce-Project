import { LightningElement, track, wire} from 'lwc';
import getAllRecords from '@salesforce/apex/WzardLWCApex.getAllRecords';
import sendEmail from '@salesforce/apex/WzardLWCApex.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// add wire where needed
export default class WizardSelection extends LightningElement {

    @track recList = [];
    @track currentStep = 1;
    @track subject;
    @track emailBody;
    @track selectedRecords = [];
    email = [];

    objOptions = [
        { label: 'Account', value: 'Account' },
        { label: 'Contact', value: 'Contact' },
        { label: 'Lead', value: 'Lead' }
    ];

    columnsForRec = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name' }, 
        { label: 'Email', fieldName: 'Email' }
    ];
    
    handleChangeSelect(event) {
        let selectedObj = event.target.value;
        if(selectedObj == 'Account'){
            this.columnsForRec[2].fieldName = 'Email__c';
        }
        console.log(selectedObj);

        getAllRecords({obj: selectedObj})
        .then(data => {
            this.recList = data;
        }).catch(error => {
            console.log(error);
        });
    }

    @track currentStep = '1';
 
    handleOnStepClick(event) {
        this.currentStep = event.target.value;
    }
 
    get isStepOne() {
        return this.currentStep === "1";
    }
 
    get isStepTwo() {
        return this.currentStep === "2";
    }
 
    get isStepThree() {
        return this.currentStep === "3";
    }
 
    get isEnableNext() {
        return this.currentStep != "3";
    }
 
    get isEnablePrev() {
        return this.currentStep != "1";
    }
 
    get isEnableFinish() {
        return this.currentStep === "3";
    }

    handleNext() {
        if (this.currentStep === "1") {
            // Fetch selected records from the datatable
            // let selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
            let selectedRow = this.template.querySelector("lightning-datatable").getSelectedRows();

            console.log(selectedRow);
            if (selectedRow.length === 0) {
                alert("Please select at least one record before proceeding.");
                return;
            }
    
            // Store selected record IDs
            selectedRow = selectedRow.map(record => record.Id);
            this.selectedRecords.push(...selectedRow);
            // this.selectedRecords = selectedRow.map(record => record.Id);
            console.log("Selected Records:", this.selectedRecords);
    
            this.currentStep = "2";  // Move to Step 2
        } 
        else if (this.currentStep === "2") {
            if (!this.subject || !this.emailBody) {
                alert("Please enter both Subject and Email Body before proceeding.");
                return;
            }
    
            this.currentStep = "3";  // Move to Step 3
        }
    }
    

    handlePrev(){
        if(this.currentStep == "3"){
            this.currentStep = "2";
        }
        else if(this.currentStep == "2"){
            this.currentStep = "1";
        }
    }
    
    handleCheckboxChange(event) {
        const recordId = event.target.value;
        console.log(event.target.checked)
        if (event.target.checked) {
            this.selectedRecords.push(recordId);
        } else {
            this.selectedRecords = this.selectedRecords.filter(id => id !== recordId);
        }
    }

    handleSubjectChange(event) {
        this.subject = event.target.value;
        // console.log(this.subject);
    }


    handleChangeDraft(event) {
        this.emailBody = event.target.value;
        // console.log(this.emailBody);
    }

    handleSendEmail1() {
        // add emails in emaillist
        // this.emailList = [];
        // this.selectedRecords.forEach(record => {
        //     this.emailList.push(record.email.toString());
        // });
        this.emailList = this.recList
            .filter(record => this.selectedRecords.includes(record.Id))
            .map(record => record.Email);


        console.log('SendEmail called: ' + this.subject, this.emailBody, this.emailList);

        if(this.selectedRecords.length === 0) {
            alert("Please select at least one record before proceeding.");
            return;
        }
        if(!this.subject || !this.emailBody) {
            alert("Please enter both Subject and Email Body before proceeding.");
            return;
        }
        console.log(this.subject, this.emailBody, this.selectedRecords);
        sendEmail({ subject: this.subject, body: this.emailBody, recordIds: this.emailList })
            .then(() => {
                // alert('Email sent successfully!');
                this.toastSendMail();
                this.resetState();
            })
            .catch(error => {
                console.error('Error sending email', error);
            });
    }
    handleSendEmail() {
        this.emailList = this.recList
            .filter(record => this.selectedRecords.includes(record.Id))
            .map(record => record.Email || record.Email__c);
    
        console.log('Selected Records:', JSON.stringify(this.selectedRecords));
        console.log('Emails to send:', JSON.stringify(this.emailList));
        
        if (this.emailList.length === 0) {
            alert("No valid email addresses found.");
            return;
        }
    
        sendEmail({ subject: this.subject, body: this.emailBody, emailList: this.emailList })
            .then(() => {
                this.toastSendMail();
                this.resetState();
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

    resetState() {
        this.currentStep = '1';
        this.subject = '';
        this.emailBody = '';
        this.selectedRecords = [];
    }
} 
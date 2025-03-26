import { LightningElement, wire, track, api } from 'lwc';
import fetchRelatedData from  "@salesforce/apex/GetAllAccountsForLWC.fetchRelatedData";
import { subscribe, MessageContext } from 'lightning/messageService';
import ACCOUNT_CONTACT_OPP_CHANNEL from '@salesforce/messageChannel/AccountContactOppChannel__c';

export default class ConOppLMS extends LightningElement {
    subscription = null;
    @api accountId;
    @wire(MessageContext)
    messageContext;

    contacts = [];
    opportunities = [];
    columnsForContact = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name' },
        { label: 'Email',  fieldName: 'email' , type: 'email'},
        { label: 'Phone', fieldName: 'Phone' },
        { label: 'AccountId', fieldName: 'AccountId' },
    ];

    columnsForOpportunity = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name' },
        { label: 'Type', fieldName: 'Type' },
        { label: 'StageName', fieldName: 'StageName' },
        { label: 'Amount', fieldName: 'Amount' },
        { label: 'CloseDate', fieldName: 'CloseDate' },
    ];

    connectedCallback() {
        console.log('In connectedCallback');
        this.subscription = subscribe(this.messageContext, ACCOUNT_CONTACT_OPP_CHANNEL, (message) => {
            this.accountId = message.accountId;
            this.displayRelatedData();
        });
    }

    displayRelatedData() {
        console.log('AccId: '+ this.accountId);
        fetchRelatedData({accId: this.accountId}) 
        .then(data => {
            this.contacts = data.conList;
            this.opportunities = data.oppList;
        })
        .catch(error => {
            console.log(error);
        });
        
    }
} 


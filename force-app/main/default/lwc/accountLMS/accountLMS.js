import { LightningElement, wire } from 'lwc';
import getAccounts from  "@salesforce/apex/GetAllAccountsForLWC.getAllAccounts";
import { publish, MessageContext } from 'lightning/messageService';
import ACCOUNT_CONTACT_OPP_CHANNEL from '@salesforce/messageChannel/AccountContactOppChannel__c';

export default class AccountLMS extends LightningElement {

    @wire(MessageContext)
    messageContext;

    errors; 
    accountOptions = [];
    selectedAccountId = undefined ;
    connectedCallback()
    {
        this.getAccountsDetails();
    }
    getAccountsDetails()
    {
        getAccounts({})
        .then((result) => 
        {
            this.accountOptions = [];
            // console.log('UAC: result ' + JSON.stringify(result)) ;
            result.forEach(ac => {
                this.accountOptions.push({
                  label: ac.Name,
                  value: ac.Id,
                });
            });
            this.isLoading = false;
            this.errors = undefined;
        })
        .catch((error) => 
        {
            this.errors = error;
            this.isLoading = false;
        });
    }

    handleChange(event)
    {
        this.selectedAccountId = event.detail.value;
        console.log('UAC: handleChange ENTRY ' + this.selectedAccountId);
        const payload = { accountId: this.selectedAccountId };
        publish(this.messageContext, ACCOUNT_CONTACT_OPP_CHANNEL, payload);
    }
}


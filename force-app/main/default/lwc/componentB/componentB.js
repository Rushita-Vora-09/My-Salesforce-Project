import { LightningElement, wire } from 'lwc';
import { subscribe,MessageContext } from 'lightning/messageService';
import COMPONENT_COMMUNICATION_CHANNEL from '@salesforce/messageChannel/ComponentCommunicationChannel__c';

export default class ComponentB extends LightningElement {

    @wire(MessageContext) 
    messageContext;
    
    subscription = null;
    receivedMessage = 'No message received yet!';

    connectedCallback() {
        if(!this.subscription) {
            this.subscription = subscribe (
                this.messageContext,
                COMPONENT_COMMUNICATION_CHANNEL,
                (payload) => this.handleMessage(payload)
            );
        }
    }

    handleMessage(payload){
        console.log('Received Payload: ',payload);
        this.receivedMessage = payload.message;
    }
}
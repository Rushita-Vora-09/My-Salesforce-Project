import { LightningElement, wire } from 'lwc';
import {publish, MessageContext} from 'lightning/messageService';
import COMPONENT_COMUNICATION_CHANNEL from '@salesforce/messageChannel/ComponentCommunicationChannel__c';

export default class ComponentA extends LightningElement {
    @wire(MessageContext) 
    messageContext;

    handleButtonClick() {
        const msgInput = this.template.querySelector('lightning-input').value;
        const payload = {
            message: msgInput
        };

        publish(this.messageContext, COMPONENT_COMUNICATION_CHANNEL, payload);
    }
}
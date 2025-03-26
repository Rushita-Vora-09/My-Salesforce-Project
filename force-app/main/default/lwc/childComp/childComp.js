import { LightningElement, api } from 'lwc';

export default class ChildComp extends LightningElement {

    @api childProperty1;
    @api childProperty2;

    @api callChildMethod() {
        console.log('child method get called');
        this.ChildProperty2='';
    }
    // additional function
    sendToParent() {
        console.log('parent method get called');
        const inputValue=this.template.querySelector('lightning-input').value;
        let evt = new CustomEvent('send', {detail: inputValue});
        this.dispatchEvent(evt);
    }
}
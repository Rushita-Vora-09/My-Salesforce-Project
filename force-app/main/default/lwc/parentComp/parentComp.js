import { LightningElement } from 'lwc';

export default class ParentComp extends LightningElement { 

    // emptyChildProperty(event)
    // {
    //     const childMessage=this.template.querySelector('c-child-comp');
    // }

    childMessage='No message received';

    storeMessage(event){
        console.log(event.detail);
        this.childMessage=event.detail;
    }
}
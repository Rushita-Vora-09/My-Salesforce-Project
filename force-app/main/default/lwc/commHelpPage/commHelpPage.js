import { LightningElement } from 'lwc';
import STCommHelpPageImage from '@salesforce/resourceUrl/STCommHelpPageImage';
import HELP_PAGE from '@salesforce/label/c.HelpPageSTCommunity';
import HELP_PAGE1 from '@salesforce/label/c.HelpPageSTCommunity1';
import HELP_PARA from '@salesforce/label/c.HelpPageSTCommunityPara';
import BTN1 from '@salesforce/label/c.HelpPageSTCommunityB1';
import BTN2 from '@salesforce/label/c.HelpPageSTCommunityB2';
import ONE from '@salesforce/label/c.HelpPageSTCommunityONE';
import TWO from '@salesforce/label/c.HelpPageSTCommunityTWO';
import THREE from '@salesforce/label/c.HelpPageSTCommunityTHREE';
import ONEPARA from '@salesforce/label/c.HelpPageSTCommunityONEPara';
import TWOPARA from '@salesforce/label/c.HelpPageSTCommunityTWOPara';
import THREEPARA from '@salesforce/label/c.HelpPageSTCommunityTHREEPara';

export default class CommHelpPage extends LightningElement {
    // This is a placeholder for the CommHelpPage component
    // You can add any necessary JavaScript functionality here
    // For example, you might want to handle events or manage state

    label = {
        HELP_PAGE,
        HELP_PAGE1,
        HELP_PARA,
        BTN1,
        BTN2,
        ONE,
        TWO,
        THREE,
        ONEPARA,
        TWOPARA,
        THREEPARA,
    };
    HelpPageImage = STCommHelpPageImage;
      
    connectedCallback() {
        console.log('CommHelpPage component is connected');
    }

    handleClick() {
        console.log('Clicked');
    }
}
import { LightningElement, track } from 'lwc';

export default class CommWelcomePopup extends LightningElement {
    // @track showPopup = false;

    // connectedCallback() {
    //     // Check session storage to determine if the welcome message should be shown
    //     if (!sessionStorage.getItem('welcomeShown')) {
    //         this.showPopup = true;
    //         sessionStorage.setItem('welcomeShown', 'true');
    //         this.dispatchEvent(new CustomEvent("updateGTMdataLayer", { "detail" : { data: "test"} }));
    //     }
    // }

    // closePopup() {
    //     this.showPopup = false;
    // }

    @track showPopup = false;

    connectedCallback() {
        document.addEventListener("showWelcomePopup", () => {
            console.log("Welcome Popup Event Received!"); // Debugging log
            this.showPopup = true;
        });
    }

    closePopup() {
        this.showPopup = false;
    }
} 
import { LightningElement, track } from 'lwc';
export default class FileUploaderCompLwc extends LightningElement {
    @track imageUrl;
    
    handleFileUpload(event) {
        const file = event.target.files[0];
        if(file) {
            var reader = new FileReader()
            reader.onload = () => {
                this.imageUrl = reader.result;
            }
        }
        reader.readAsDataURL(file)
    }
}
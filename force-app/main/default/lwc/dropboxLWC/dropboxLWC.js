import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFileByRecord from '@salesforce/apex/DropboxController.uploadFileByRecord'; 
import deleteFile from '@salesforce/apex/DropboxController.deleteFile';
import { RefreshEvent } from "lightning/refresh";

export default class DropboxLWC extends LightningElement {
    @api recordId;
    @track imageUrls = [];
    displayFiles = [];

    handleUploadFinished(event) { 
        console.log('start');
        let docId = [];
        let uploadedFiles = event.detail.files;
        for (let file of uploadedFiles)
        {
            docId.push(file.documentId);
        }

        uploadFileByRecord({ recordId: this.recordId, documentIds: docId })
                .then(data => {
                    console.log('Fetched uploaded files:');
                    console.log(data);
                    this.displayFiles = data;
                })
                .catch(error => {
                    console.log('error');
                    console.log(error);
                });

        try{
            console.log('content ');
            console.log('displayFiles');
            console.log(this.displayFiles);
            console.log('uploadedFiles');
            console.log(uploadedFiles);
            // console.log(typeof(uploadedFiles[0]));
            this.showToast(uploadedFiles.length+' Files Uploaded Successfully', 'Uploaded files displayed below');
            this.dispatchEvent(new RefreshEvent());
        } catch (error) {
            console.error('Error uploading file:', error);
            alert(error.message);
        }
    }

    showToast(title, message) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    handleDeleteFile(event) {
        console.log('delete file');
        console.log(event.target.value);

        const fileDocId = event.target.value;
        console.log(typeof(fileDocId));
        // delete file by fileId
        deleteFile({ fileDocId: fileDocId, recordId: this.recordId })
            .then(() => {
                console.log('File deleted successfully');
                this.showToast('File Deleted Successfully', 'File has been deleted successfully');
                this.displayFiles = this.displayFiles.filter(file => file.Id !== fileDocId);
                this.dispatchEvent(new RefreshEvent());
            })
            .catch(error => {
                console.error('Error deleting file:', error);   
                alert(error.message);
            });
    }
}
// MultipleFileUploader.js
import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MultipleFileUploader extends LightningElement {
    @api recordId;
    @track imageUrls = [];
    @track currentPage = 1;
    itemsPerPage = 2;

    get acceptedFormats() {
        return ['.png','.jpg','.jpeg'];
    }

    get totalPages() {
        return Math.ceil(this.imageUrls.length / this.itemsPerPage) || 1; // if imageUrls is empty, we still want to display 1 page 
    }

    get paginatedImages() {
        const start = (this.currentPage - 1) * this.itemsPerPage;
        return this.imageUrls.slice(start, start + this.itemsPerPage);
    }

    handleUploadFinished(event) { 
        const uploadedFiles = event.detail.files;
        console.log(uploadedFiles);
        this.showToast(uploadedFiles.length+' Files Uploaded Successfully', 'Uploaded files displayed below');
        for(let i = 0; i < uploadedFiles.length; i++) {
            this.imageUrls.push({
                fileName: uploadedFiles[i].name,
                fileUrl: `/sfc/servlet.shepherd/document/download/${uploadedFiles[i].documentId}` // also work
                // fileUrl: `/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=${uploadedFiles[i].contentVersionId}`
            });
        }
    }
    // show toast
    showToast(title, message) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    handlePageChange(event) {
        this.currentPage = event.detail.currentPage;  
    }
}

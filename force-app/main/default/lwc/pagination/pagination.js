// pagination.js
import { LightningElement, api, track } from 'lwc';

export default class Pagination extends LightningElement {
    @api totalPages = 1;
    @track currentPage = 1;

    get isPrevDisabled() {
        return this.currentPage === 1;
    }

    get isNextDisabled() {
        return this.currentPage === this.totalPages;
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.dispatchPageChangeEvent();
        }
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.dispatchPageChangeEvent();
        }
    }

    dispatchPageChangeEvent() {
        this.dispatchEvent(new CustomEvent('pagechange', {
            detail: { currentPage: this.currentPage }
        }));
    }
}
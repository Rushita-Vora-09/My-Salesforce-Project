import { LightningElement, track } from 'lwc';
import searchWithSOSL from '@salesforce/apex/SearchWithSOSLApex.searchWithSOSL';

export default class SearchWithSOSL extends LightningElement {

    @track searchKey;
    @track searchResults;
    // selectedObjects;
    // finalData = {}
    @track allObjects = [];

    objectOptions = [
        { label: 'Account', value: 'Account' },
        { label: 'Contact', value: 'Contact' },
        { label: 'Lead', value: 'Lead' },
        { label: 'User', value: 'User' },
        { label: 'Opportunity', value: 'Opportunity' },
        { label: 'Student', value: 'Student__c' },
        { label: 'Parent', value: 'Parent__c' },
        { label: 'Company', value: 'Company__c' }
    ]
    columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Name', fieldName: 'Name' }
    ]

    handleSearchChange(event) {
        this.searchKey = event.target.value;
    }        

    handleObjectSelection(event) {
        this.selectedObjects = event.detail.value;
        if(!this.allObjects.includes(this.selectedObjects)){
            this.allObjects.push(this.selectedObjects);
            console.log(this.allObjects);
        }
    }

    handleRemoveObject(event) {
    
        const valueRemoved = event.target.name;
        this.allObjects = this.allObjects.filter(obj => obj !== valueRemoved); // ✅ Efficient removal
    }

    handleSearch(){
        searchWithSOSL({searchKey: this.searchKey, objects: this.allObjects})
        .then(data => {

            this.searchResults = Object.keys(data).map(objName => ({
                id: objName, // Object name as ID
                records: data[objName] || [] // Ensure records exist
            }));

            console.log("Formatted Search Results:", this.searchResults);
        })
        .catch(error => {
            console.log(error);
        });
    }
   
}

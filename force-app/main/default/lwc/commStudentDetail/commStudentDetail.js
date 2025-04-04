import { LightningElement } from 'lwc';
import getStudents from '@salesforce/apex/CreateUserForCommunity.getStudents';
import getStudentDetail from '@salesforce/apex/CreateUserForCommunity.getStudentDetail';

export default class CommStudentDetail extends LightningElement {
    
    students = [];
    detail = {};
    studentDetail = false;

    connectedCallback() {
        getStudents()
            .then(result => {
                if(result!= null && result.length > 0) {
                    console.log('Students:'+ result);
                    this.students = result;
                } else {
                    console.log('No students found.');
                }
                this.students = result;
                console.log('Students:', this.students);
            }
            )
            .catch(error => {
                this.error = error;
                console.error('Error:', this.error);
            });
    }

    handleShowDetail(event) {
        
        const recordId = event.target.dataset.recordid;
        console.log('recordId:', recordId);
        if(recordId == null || recordId == '') {
            console.error('Invalid recordId:', recordId);
        }

        getStudentDetail({recordId: recordId})
            .then(result => {
                console.log('Student Detail:', result);
                this.detail = result;
                this.studentDetail = true;
                console.log('Student Detail:', this.detail);
            })
            .catch(error => {
                this.error = error; 
                console.error('Error:', this.error);
            })
    }
}
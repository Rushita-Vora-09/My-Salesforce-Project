// import { LightningElement } from 'lwc';
// import getStudents from '@salesforce/apex/CreateUserForCommunity.getStudents';
// import getStudentDetail from '@salesforce/apex/CreateUserForCommunity.getStudentDetail';

// export default class CommStudentDetail extends LightningElement {
    
//     students = [];
//     detail = {};
//     displayStudentDetail = false;

//     get studentDetail() {
//         return this.displayStudentDetail;
//     }

//     connectedCallback() {
//         getStudents()
//             .then(result => {
//                 if(result!= null && result.length > 0) {
//                     console.log('Students:'+ result);
//                     this.students = result;
//                 } else {
//                     console.log('No students found.');
//                 }
//                 this.students = result;
//                 console.log('Students:', this.students);
//             }
//             )
//             .catch(error => {
//                 this.error = error;
//                 console.error('Error:', this.error);
//             });
//     }

//     handleShowDetail1(event) {
        
//         const recordId = event.target;
//         console.log('recordId:', recordId);
//         if(recordId == null || recordId == '') {
//             console.error('Invalid recordId:', recordId);
//         }

//         getStudentDetail({recordId: recordId})
//             .then(result => {
//                 console.log('Student Detail:', result);
//                 this.detail = result;
//                 this.displayStudentDetail = true;
//                 console.log('Student Detail:', this.detail);
//             })
//             .catch(error => {
//                 this.error = error; 
//                 console.error('Error:', this.error);
//             })
//     }
//     handleShowDetail(event) {
//         const recordId = event.target.dataset.id;
//         console.log('recordId:', recordId);
        
//         if (!recordId) {
//             console.error('Invalid recordId:', recordId);
//             return;
//         }
    
//         getStudentDetail({ recordId: recordId })
//             .then(result => {
//                 console.log('Student Detail:', result);
//                 this.detail = result;
//                 this.displayStudentDetail = true;
//             })
//             .catch(error => {
//                 this.error = error;
//                 console.error('Error:', this.error);
//             });
//     }
//     handleBack() {
//         this.displayStudentDetail = false;
//         this.detail = {};
//     }
        
// }


import { LightningElement, track } from 'lwc';
import getStudents from '@salesforce/apex/CreateUserForCommunity.getStudents';
import getStudentDetail from '@salesforce/apex/CreateUserForCommunity.getStudentDetail';
import updateStudentFeedback from '@salesforce/apex/CreateUserForCommunity.updateStudentFeedback';

export default class CommStudentDetail extends LightningElement {
    @track students = [];
    @track detail = {};
    @track displayStudentDetail = false;
    @track isLoading = true;
    @track feedback = '';

    connectedCallback() {
        getStudents()
            .then(result => {
                this.students = result;
                this.isLoading = false;
            })
            .catch(error => {
                console.error('Error loading students:', error);
                this.isLoading = false;
            });
    }

    handleShowDetail(event) {
        const studentId = event.target.dataset.id;
        if (!studentId) return;

        this.isLoading = true;
        getStudentDetail({ recordId: studentId })
        .then(result => {
            this.detail = result;
            // this.feedback = result.Feedback__c || '';
            this.displayStudentDetail = true;
            this.isLoading = false;
    
            // Safely inject decoded emojis to the span using innerHTML
            setTimeout(() => {
                const outputSpan = this.template.querySelector('.feedback-output');
                if (outputSpan) {
                    outputSpan.innerHTML = this.detail.Feedback__c || '';
                }
            }, 0);
        })
    
        }

    handleBack() {
        this.displayStudentDetail = false;
        this.detail = {};
        this.feedback = '';
    }

    handleFeedbackChange(event) {
        this.feedback = event.target.value;
    }

    selectEmoji(event) {
        const emoji = event.target.dataset.emoji;
        this.feedback = (this.feedback || '') + emoji;
    }

    submitFeedback() {
        if (!this.feedback) {
            alert('Please enter feedback before submitting.');
            return;
        }

        updateStudentFeedback({ recordId: this.detail.Id, feedback: this.feedback })
            .then(() => {
                alert('Feedback submitted successfully!');
                this.feedback = ''; // ✅ Clear feedback after submission
            })
            .catch(error => {
                console.error('Error submitting feedback:', error);
                alert('Failed to submit feedback.');
            });
    }
}

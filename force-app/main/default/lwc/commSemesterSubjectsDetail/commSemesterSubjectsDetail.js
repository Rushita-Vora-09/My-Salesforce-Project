import { LightningElement, track } from 'lwc';
import getSemester from '@salesforce/apex/CreateUserForCommunity.getSemester';

export default class CommSemesterSubjectsDetail extends LightningElement {
    @track isLoading = true;
    @track semester;
    @track subjects = [];

    connectedCallback() {
        getSemester()
            .then(data => {
                this.semester = data;
                console.log('Semester:', this.semester);

                switch (this.semester) {
                    case '1':
                        this.subjects = ['Math', 'Physics', 'Chemistry'];
                        break;
                    case '2':
                        this.subjects = ['Biology', 'History', 'English'];
                        break;
                    case '3':
                        this.subjects = ['Computer Science', 'Statistics', 'Economics'];
                        break;
                    case '4':
                        this.subjects = ['Geography', 'Political Science', 'Psychology'];
                        break;
                    case '5':
                        this.subjects = ['Data Structures', 'Algorithms', 'Database Management'];
                        break;
                    case '6':
                        this.subjects = ['Probability and Statistics', 'Economics', 'Physics'];
                        break;
                    default:
                        this.subjects = ['Semester is not selected for this student!'];
                        break;
                }

                this.isLoading = false;
            })
            .catch(error => {
                console.error(error);
                this.isLoading = false;
            });
    }
}

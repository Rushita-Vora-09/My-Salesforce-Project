import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CommStudentsTab extends NavigationMixin(LightningElement) {
    openStudentTab() {
        this[NavigationMixin.GenerateUrl]({
            type: "standard__webPage",
            attributes: {
              url: "https://mvclouds-df-dev-ed.develop.my.site.com/stportal/s/my-students",
              isNavTabPersistenceDisabled : true,
           },
         }).then((generatedUrl) => {
         window.open(generatedUrl);
      });
    }
}

import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CommClassSemesterTab extends NavigationMixin(LightningElement) {
    openClassSemesterTab() {
        this[NavigationMixin.GenerateUrl]({
            type: "standard__webPage",
            attributes: {
              url: "https://mvclouds-df-dev-ed.develop.my.site.com/stportal/s/class-semester",
              isNavTabPersistenceDisabled : true,
           },
         }).then((generatedUrl) => {
         window.open(generatedUrl);
      });
    }
}

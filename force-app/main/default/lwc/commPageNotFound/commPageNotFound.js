import { LightningElement } from 'lwc';
import BackgroundImg from '@salesforce/resourceUrl/Page_Not_Found_Image';
import { NavigationMixin } from 'lightning/navigation';

export default class CommPageNotFound extends NavigationMixin(LightningElement) {
    imageUrl = BackgroundImg;

    handleClick() {
            this[NavigationMixin.GenerateUrl]({
                type: "standard__webPage",
                attributes: {
                  url: "https://mvclouds-df-dev-ed.develop.my.site.com/stportal/s",
                  isNavTabPersistenceDisabled : true,
               },
             }).then((generatedUrl) => {
             window.location(generatedUrl);
          });
        }
}
import { LightningElement, api } from 'lwc';
import { BaseLayout } from "vlocity_cmt/baseLayout";
import { NavigationMixin } from 'lightning/navigation';

export default class CustomCommunityThemeLayout extends NavigationMixin(LightningElement) {
    headerText = 'Default Header'; // Customizable header text
    backgroundColor = '#FFFFFF'; // Customizable background color

    // Dynamic style for the container
    get containerStyle() {
        return `background-color: ${this.backgroundColor};`;
    }

    // Navigate to Home page
    navigateToHome() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home'
            }
        });
    }

    // Navigate to My Profile page
    navigateToProfile() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Profile'
            }
        });
    }

    // Navigate to Logout
    navigateToLogout() {
        this[NavigationMixin.Navigate]({
            type: 'comm__loginPage',
            attributes: {
                actionName: 'logout'
            }
        });
    }
}
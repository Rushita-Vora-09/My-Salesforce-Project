public class AddRandomImageToOpportunity {
    private ApexPages.StandardController standardController;
    public AddRandomImageToOpportunity(ApexPages.StandardController standardController){
        this.standardController = standardController;
        // AddRandomImageToOpportunity.attachRandomImage('006WU0000091NVNYA2');

    }
    public void someAction(){
        AddRandomImageToOpportunity.attachRandomImage(standardController.getId());
        // return null;
    }

    @future(callout=true)
    public static void attachRandomImage(Id opportunityId) {
        String ACCESS_KEY = 'FHTQ_f8Ob8svXdS7gkavG1X5ZPp2-T6UuFhcAjWqrVw';
        try {
            // Define the API endpoint to fetch random image
            // Id opportunityId = Id.valueOf(opportunityIds);
            Integer randomCount = Integer.valueof((Math.random() * 100));
            System.debug('Random Count: ' + randomCount);
            // String apiUrl = 'https://loremflickr.com/1200/700?random='+randomCount; 
            String apiUrl = 'https://loremflickr.com/cache/resized/65535_53886892194_dfb97da0c0_h_1200_700_nofilter.jpg';
            // String apiUrl = 'https://api.unsplash.com/search/photos?page=3&query=random&client_id=FHTQ_f8Ob8svXdS7gkavG1X5ZPp2-T6UuFhcAjWqrVw';
            // Perform HTTP callout
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('GET');

            HttpResponse response = http.send(request);
            System.debug('Status code: ' + response.getStatusCode());
            if (response.getStatusCode() == 200) {
                Blob imageBlob = response.getBodyAsBlob();
                String fileName = 'RandomImage_' + randomCount + DateTime.now() + '.jpg';

                // Create ContentVersion record (file)
                ContentVersion contentVersion = new ContentVersion();
                contentVersion.Title = fileName;
                contentVersion.PathOnClient = fileName;
                contentVersion.VersionData = imageBlob;
                contentVersion.FirstPublishLocationId = opportunityId;
                insert contentVersion;
            } else {
                System.debug('Failed to fetch image: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            // ErrorLog.insertError(new ErrorWrapper(e, 'AddRandomImageToOpportunity.attachRandomImage', 'Failed to attach random image'));
            System.debug('Error in attachRandomImage: ' + e.getMessage());
        }
    }
}
// AddRandomImageToOpportunity.attachRandomImage('006WU0000091NVNYA2');

// @future Annotation
// method should be static
// method return type should be void
// method should have only primitive datatypes or collection of sObjects arguments
// future method cannot call another future method
// future method cannot be invoked by batch class
// callout=true is required for future method to make callouts from any third party services

// String apiUrl = 'https://loremflickr.com/1200/700?random=1'; 


// <apex:page controller="myFutureButtonController" ></apex:page>


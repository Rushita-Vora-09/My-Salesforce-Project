({
    handleImageUpload : function(component, event, helper) {
        var imgUrl = event.getParam("imageUrl");
        console.log("Received Image URL in Parent: ", imgUrl);
        if(imgUrl) {
            component.set("v.uploadedImg", imgUrl);
        } else {
            console.error("No image URL received in event.");
        }
    }
});
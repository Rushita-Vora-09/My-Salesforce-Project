({
    handleFileUpload : function(component, event, helper) {
        var file = event.getSource().get("v.files")[0];

        if (file) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var imgUrl = e.target.result;
                component.set("v.uploadedFile", imgUrl);

                // Fire the event
                // var uploadEvent = $A.get("e.c:ImgUploadEvent");
                var uploadEvent = component.getEvent("ImgUploadEvent");
                if (uploadEvent) {
                    uploadEvent.setParams({ 
                        imageUrl: imgUrl 
                    });
                    uploadEvent.fire();
                } else {
                    console.error("Event not found: ImgUploadEvent");
                }
            };
            reader.readAsDataURL(file);
        }
    }
    
});
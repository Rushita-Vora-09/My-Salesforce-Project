// test class and mock class for DropboxController 
@isTest
private class DropboxControllerTest {

    // test method for uploadFileToDropbox
    static testMethod void testUploadFileToDropbox() {
        // create contect for relared link and version
        Contact con = new Contact();
        con.LastName = 'Test';
        insert con;

        // extension for conent file
        ContentVersion content = new ContentVersion();
        content.Title = 'Test';
        content.PathOnClient = 'Test';
        Blob b = Blob.valueOf('Test Data');
        content.VersionData = b;
        content.IsMajorVersion = true;
        content.ContentLocation = 'S';
        insert content;
        
        Id docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:content.Id].ContentDocumentId;
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = docId;
        cdl.LinkedEntityId = con.Id;
        // cdl.ShareType = 'V';
        insert cdl;
        System.debug(cdl.ContentDocumentId);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DropBoxConnectionTestMock());
        DropboxController.uploadFileByRecord(con.id,new List<Id>{docId});
        DropboxController.deleteFile(docId,con.id);
        DropboxController.deleteFile('',con.id);
        Test.stopTest();

    }
}
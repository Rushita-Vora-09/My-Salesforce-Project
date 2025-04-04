// test class and mock class for DropboxController 
@isTest
private class DropboxServiceTest {

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
        DropboxService.upload(content);
        DropboxService.deleteFile(docId);
        DropboxService.deleteFile('');
        Test.stopTest();

    }
}
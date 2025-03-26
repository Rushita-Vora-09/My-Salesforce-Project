public class DropboxController 
{
    @AuraEnabled 
	public static List<ContentDocument> uploadFileByRecord(string recordId, List<Id> documentIds)
    {
  
        List<ContentDocumentLink> links=[SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where LinkedEntityId=:recordId];
        Set<Id> ids=new Set<Id>();
        for(ContentDocumentLink link:links)
        {
            ids.add(link.ContentDocumentId);
        }
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :documentIds AND IsLatest = true]; 
        
        List<ContentDocument> documents=[SELECT Id,Title,FileExtension FROM ContentDocument WHERE Id IN :ids];
        System.debug('documents:'+documents);
        List<String> fileNames=new List<String>();
        for(ContentDocument doc:documents)
        {
            System.debug('doc:' + doc);
            fileNames.add(doc.Title+'.'+doc.FileExtension);
        }

        List<FileStore__c> fileStores = new List<FileStore__c>();
        for(ContentVersion attach:versions)
        {
            string fileUrl=DropboxService.upload(attach);
            if (string.isNotBlank(fileUrl)) 
            {
                try {
                    //Store Information in Object
                    //Will be used for retrieving files
                    FileStore__c fileStore=new FileStore__c();
                    fileStore.ServerUrl__c=fileUrl;
                    fileStore.Name=attach.Title +'.'+  attach.FileExtension.toLowerCase();
                    fileStore.RecordId__c=recordId;
                    fileStore.FileExtension__c=attach.FileExtension.toLowerCase();
                    fileStores.add(fileStore);
                }
                catch (Exception e) {
                    System.debug('Error'+e.getMessage());
                }
            }
            System.debug('fileStores:'+fileStores);
        }
        if (!fileStores.isEmpty()) {
            insert fileStores;
        }
        return documents;
    }

    @AuraEnabled
    public static void deleteFile(string fileDocId, string recordId)
    {
        // delete file from dropbox
        String fileUrl=DropboxService.deleteFile(fileDocId);
        // delete file from filestorage__c object using contendocumentid 
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE Id = :fileDocId];
        System.debug('documents: '+documents);
        if (!documents.isEmpty()) {
            try {
                delete documents;
            } catch (Exception e) {
                System.debug('Error:'+e.getMessage());
            }            
        }

        List<FileStore__c> fileStores=[SELECT Id,Name,ServerUrl__c,FileExtension__c FROM FileStore__c WHERE Id=:fileDocId AND RecordId__c=:recordId];
        if (!fileStores.isEmpty()) {
            try {
                delete fileStores;
            } catch (Exception e) {
                System.debug('Error:'+e.getMessage());
            }
        }
    }
}

// run dropbox controller
// DropboxController.uploadFileByRecord('001WU00000hxtjVYAQ'); //0012v00003JMBTqAAP is Account record where file is attached

public class DropboxService {
    // when update access token, also verifiy in named credentials by resave named credentials
    private static final String ACCESS_TOKEN = 'sl.u.AFkuD5DYNF3O45BVdXHfTeL8_CMj_7Uub0yEcjUmyA74x-bJad-JdT4POR97GCnyDXbCu-17ZZGiUsX9Gehwzl1_RCa3J_aeiRy8e7JE3kTpDqYDXY8RAsv3usQfTKQzPRUh6LJhhVCSJ4sS7J2k5Kv54kLSkrkQBJewVn_u8xdzB6ednNDzptLnVChXV8uap7aOfJK6_EYMWkKJhu0K6miT05mNfeAOTmQEyD4o8PmM72cGlM-VaOxhSVfHL8qyNaHXF8UMhhHI9Eumbzj24LCInOdEauk2Hyo35dBF-jnaJ10kNLgBFY09uaswj6Eh3zHxB-zmO7rb6lCGIZDWwhrT4Fn6cBlIwUks_0jl4Nfi22W9_DVW3EZT4Dix9xg-heZC4ZM4cJzgEgNgoOys75mODJ7bPTauB67O6MQfVVuB2CfLKLA9O6lFm176N2lQg7XW5sW2khG-lFhRtfd-kT5KdFID7dQMgAo3P--JkF3Vngs2iFI-NOpD9IJUJr0GmQW-yy4Gc_rJoQxkFZYHtsHmZMK2ouuorRRNfwimIgNhcvfjnlVer21FKwhfUXkydFmj1d669vsAViVNjKw4g1H3AXtantJLthyBwtp0UO-GRZf55FI9JCBLUBBCsoPMDiYFk7PXuhTzmXgq04O8C8Uz_ycvmjNm0Or8apAxNicO6Km2nTA2ChBG8Iacku895xiwbTj66PLU02E-IxrBaQcfMbYslsHbkHaaEahnjz1prNsYaSSU-6QTI3sK_luPgpxL8PPuZglrL2J-_75SDEoMhRbxFjG7SRm7fvkcmGvEeo3ZN3mHWEcqd0LAJs519WcxWyBLHiBRiRN60unyPiajgsdSG3ZfNNqE6K-tPB-rA4od_4CYh9xYXunSSkMfO1OH45SjrnJLbv3fmTaW5s3i12T7F6BuZV9t0f5qiSU26iyFBBMzg40XLc5XkhR45qQ2JEVzsm-MQ6bKYef3KCnooWTnfUEyahTLMd2cu0A6e0VjPjon5NclqpjrP5ZSfsgLrXXigOK24uGbKnzsLcTocXS9gdIQXFDx2AywyD4TsQp59RvXZhaCMiKDZrka9C3ae3VbPCgJPwAJPv2rBrMt2ZlIlEN1J6colZtoU2OzyxlDU09aqSpLIK4-Ro0t3EfLOq1eMXOEMCtXfl-kV71k7zjYeGbQsIbGcFFzLUqGqIZKJCEXh2VovgC-5Be89vpH78CHVchzm84mU8-OGfq90pnA-JqYMlFIw4zuCdQQXV7XyrZFFtbOBx0zG6WjgxaUJPdABb5kr_tkEUy-k31he_iHAPOSpeovwmyX9iMJs3Ut-DjkgXYPXfYFfzx1lDIQ4Te-0u1Ty3RUY5qPqWUYTh4XUyCHHMX1XRN7jCepMgK1sUK5LM2YqBZaLvzO1y32b5RZD3FXvkujSZfrs1wxUuHEgG4SN5NxV9F9E8ZnGQ';
    public class Header {
        public string path{get;set;}
        public string mode{get;set;} 
        public boolean autorename{get;set;}
        public boolean mute{get;set;}
        public boolean strict_conflict{get;set;}
    }
    private static string fileLocation(string file)
    {
    return '/SalesforceFiles/'+file;  // Change Folder based on your requirement
    }
    private static string createHeaderArgs(string file)
    {
        Header header=new Header();
        header.path=fileLocation(file);
        header.mode='add';
        header.autorename=true;
        header.mute=false;
        header.strict_conflict=false;
        return JSON.serialize(header);
    }
    @AuraEnabled
    public static string upload(ContentVersion content)
    {
        // get token from custom metadata
        // generate new token when you run this code (ERROR - token expired)
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','application/octet-stream');
        req.setMethod('POST');
        req.setEndpoint('callout:Dropbox/2/files/upload');
        // req.setEndpoint('https://content.dropboxapi.com/2/files/upload');
        req.setBodyAsBlob(content.VersionData);
        string fileName=content.Title+'.'+content.FileExtension;
        req.setHeader('Dropbox-API-Arg', createHeaderArgs(content.Title+'.'+content.FileExtension));
        req.setHeader('Authorization','Bearer '+ACCESS_TOKEN);
        req.setTimeout(120000);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug('Response:'+res.getBody());

        return fileLocation(fileName);
    }

    @AuraEnabled
    public static string deleteFile(String fileDocId){
        try {
            System.debug('fileDocId:'+fileDocId);
            // get file name from document id
            ContentVersion file=[SELECT Id, Title, FileExtension FROM ContentVersion where ContentDocumentId=:fileDocId limit 1];
            String fileName=file.Title+'.'+file.FileExtension;
            System.debug('fileName:'+fileName);
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint('callout:DropboxDeleteFile/2/files/delete_v2');
            req.setHeader('Authorization','Bearer '+ACCESS_TOKEN);
            req.setHeader('Content-Type','application/json');
            req.setBody('{"path":"/SalesforceFiles/'+fileName+'"}');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('Response:'+res.getBody());
            if(res.getStatusCode()==200)
            {
                return res.getBody();
            }
            return res.getStatusCode()+'';
        } catch (Exception e) {
            System.debug('Error:'+e.getMessage());
            return e.getMessage();
        }
    }
}
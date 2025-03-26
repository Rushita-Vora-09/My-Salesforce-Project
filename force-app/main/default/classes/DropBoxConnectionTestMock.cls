@isTest
global class DropBoxConnectionTestMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"mockKey":"mockValue"}');
        res.setStatusCode(200);
        return res;
    }
}
@isTest
public class MockHTTPResponseGenerator implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('GET', req.getMethod());
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(response());
        res.setStatusCode(200);
        return res;
    }

    private string response() {
        String responsejson =		'{'+
		'	"size": 26,'+
		'	"totalSize": 26,'+
		'	"done": true,'+
		'	"queryLocator": null,'+
		'	"entityTypeName": "MetadataComponentDependency",'+
		'	"records": [{'+
		'		"MetadataComponentName": "Test1",'+
		'		"MetadataComponentType": "CustomSites",'+
		'		"RefMetadataComponentName": "Default Menu1",'+
		'		"RefMetadataComponentType": "Navigation Menu"'+
		'	}, {'+
		'		"MetadataComponentName": "Test1",'+
		'		"MetadataComponentType": "CustomSites",'+
		'		"RefMetadataComponentName": "Default Menu2",'+
		'		"RefMetadataComponentType": "Navigation Menu"'+
		''+
		'	}]'+
        '}';
        return responsejson;
    }
}

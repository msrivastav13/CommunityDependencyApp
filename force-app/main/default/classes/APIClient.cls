public inherited sharing class APIClient {
    public static String makeAPICall(String endPoint, String method) {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setHeader(
                'Authorization',
                'Bearer ' + SessionHelper.getSessionId()
            );
            request.setTimeout(60000);
            request.setEndpoint(endPoint);
            request.setMethod(method);
            HttpResponse response = http.send(request);
            return response.getBody();
        } catch (Exception ex) {
            system.debug('Exception in tooling API Call:' + ex.getMessage());
            return ex.getMessage();
        }
    }
}

public with sharing class SfccApiTestCall {
    @future(callout=true)
    public static void testCall() {
        Http transport = new Http();
        HttpRequest req = new HttpRequest();
        SfccAccessTokenMgr tokenMgr = new SfccAccessTokenMgr();

        req.setMethod('GET');
        req.setEndpoint('https://********.api.commercecloud.salesforce.com/product/products/v1/organizations/f_ecom_***_dev/products/asd');

        tokenMgr.authorizeRequest(req, 'dev');

        HttpResponse res = transport.send(req);

        System.debug('API request');
        System.debug(res.getStatusCode());
        System.debug(res.getBody());
    }
}

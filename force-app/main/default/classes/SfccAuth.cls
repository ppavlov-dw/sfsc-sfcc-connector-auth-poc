public with sharing class SfccAuth {
    private String realm;
    private String apiClientId;
    private String[] scopes;

    public SfccAuth(String realm, String apiClientId, String[] scopes) {
        this.realm = realm;
        this.apiClientId = apiClientId;
        this.scopes = scopes;
    }

    public SfccApiTokenResponse getNewAccessToken(String env) {
        Datetime now = Datetime.now();
        String jwt = new SfccJwt(this.apiClientId).get();

        Http transport = new Http();
        HttpRequest req = new HttpRequest();

        String body = 'grant_type=client_credentials'
        + '&client_assertion_type=' + EncodingUtil.urlEncode('urn:ietf:params:oauth:client-assertion-type:jwt-bearer', 'UTF-8')
        + '&client_assertion=' + EncodingUtil.urlEncode(jwt, 'UTF-8')
        + '&scope=SALESFORCE_COMMERCE_API:' + EncodingUtil.urlEncode(this.realm + '_' + env + ' ' + String.join(this.scopes, ' '), 'UTF-8');

        req.setMethod('POST');
        req.setBody(body);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint('https://account.demandware.com/dwsso/oauth2/access_token');

        System.debug('access token request');
        System.debug(req.getBody());
        System.debug(jwt);

        HttpResponse res = transport.send(req);

        System.debug('access token response');
        System.debug(res.getStatusCode());
        System.debug(res.getBody());

        if (res.getStatusCode() == 200) {
            SfccApiTokenResponse result = SfccApiTokenResponse.parse(res.getBody());

            return result;
        }

        return null;
    }
}

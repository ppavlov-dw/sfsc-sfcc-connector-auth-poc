public without sharing class SfccAccessTokenMgr {
    private Integer expiryWindow = 300;

    private SfccAccessTokenRepository tokenRepo = new SfccAccessTokenRepository();

    public void updateAccessToken(SFCC_Environment__c env) {
        Datetime now = Datetime.now();

        SFCC_API_Access_Token__c currentToken = this.tokenRepo.getCurrentToken(env);

        if (currentToken != null && currentToken.Expiry_Time__c >= now.addSeconds(this.expiryWindow)) {
            return;
        }

        SfccAuth authMgr = new SfccAuth(env.Realm__c, env.Client_ID__c, env.Scopes__c.split(';'));
        SfccApiTokenResponse newTokenContent = authMgr.getNewAccessToken(env.Name);

        if (currentToken == null) {
            this.tokenRepo.createAccessToken(env, newTokenContent.access_token, newTokenContent.expires_in);
        } else {
            this.tokenRepo.updateAccessToken(currentToken, newTokenContent.access_token, newTokenContent.expires_in);
        }
    }

    public void authorizeRequest(HttpRequest req, SFCC_Environment__c env) {
        SFCC_API_Access_Token__c currentToken = this.tokenRepo.getCurrentToken(env);

        if (currentToken != null) {
            req.setHeader('Authorization', 'Bearer ' + currentToken.Access_Token__c);
        }
    }
}

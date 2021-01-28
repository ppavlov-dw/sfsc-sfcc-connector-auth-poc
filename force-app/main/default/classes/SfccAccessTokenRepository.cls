public with sharing class SfccAccessTokenRepository {
    private Datetime getExpiryTime(Integer expiresIn) {
        return Datetime.now().addSeconds(expiresIn);
    }

    public SFCC_API_Access_Token__c getCurrentToken(SFCC_Environment__c env) {
        SFCC_API_Access_Token__c[] currentTokens = [
            SELECT
                Name, Access_Token__c, Expiry_Time__c
            FROM
                SFCC_API_Access_Token__c
            WHERE
                SFCC_Environment__c = :env.Id
        ];

        if (!currentTokens.isEmpty()) {
            return currentTokens[0];
        }

        return null;
    }

    public void updateAccessToken(SFCC_API_Access_Token__c currentToken, String token, Integer expiresIn) {
        currentToken.Access_Token__c = token;
        currentToken.Expiry_Time__c = this.getExpiryTime(expiresIn);

        update currentToken;
    }

    public void createAccessToken(SFCC_Environment__c env, String token, Integer expiresIn) {
        SFCC_API_Access_Token__c newToken = new SFCC_API_Access_Token__c(
            Name = env.Name,
            Access_Token__c = token,
            SFCC_Environment__r = env,
            Expiry_Time__c = this.getExpiryTime(expiresIn)
        );

        insert newToken;
    }
}

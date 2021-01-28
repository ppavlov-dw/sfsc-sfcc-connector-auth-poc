public with sharing class SfccApiTokenResponse {
    public String access_token;
    public String token_type;
    public Integer expires_in;

    public static SfccApiTokenResponse parse(String json) {
        return (SfccApiTokenResponse) System.JSON.deserialize(json, SfccApiTokenResponse.class);
    }
}

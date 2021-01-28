public with sharing class SfccJwt {
    private String apiClientId;

    public SfccJwt(String apiClientId) {
        this.apiClientId = apiClientId;
    }

    private String base64UrlEncode(Blob input) {
        String output = EncodingUtil.base64Encode(input);

        output = output.replace('+', '-');
        output = output.replace('/', '_');

        while (output.endsWith('=')){
            output = output.subString(0, output.length() - 1);
        }

        return output;
    }

    private String buildJwtHeader() {
        JSONGenerator headerGenerator = JSON.createGenerator(false);

        headerGenerator.writeStartObject();
        headerGenerator.writeStringField('alg', 'RS256');
        headerGenerator.writeStringField('typ', 'JWT');
        headerGenerator.writeEndObject();

        return base64UrlEncode(Blob.valueOf(headerGenerator.getAsString()));
    }

    private String buildJwtPayload() {
        Datetime now = Datetime.now();
        JSONGenerator payloadGenerator = JSON.createGenerator(false);

        payloadGenerator.writeStartObject();
        payloadGenerator.writeStringField('iss', this.apiClientId);
        payloadGenerator.writeStringField('sub', this.apiClientId);
        payloadGenerator.writeStringField('aud', 'https://account.demandware.com:443/dwsso/oauth2/access_token');
        payloadGenerator.writeNumberField('iat', now.getTime() / 1000);
        payloadGenerator.writeNumberField('exp', now.addMinutes(30).getTime() / 1000);
        payloadGenerator.writeEndObject();

        return base64UrlEncode(Blob.valueOf(payloadGenerator.getAsString()));
    }

    private String buildJwtSignature(String header, String payload) {
        String inputStr = header + '.' + payload;
        Blob input = Blob.valueOf(inputStr);
        Blob signature = Crypto.signWithCertificate('RSA-SHA256', input, 'SFCC_OCAPI');

        return base64UrlEncode(signature);
    }

    public String get() {
        String header = buildJwtHeader();
        String payload = buildJwtPayload();
        String signature = buildJwtSignature(header, payload);

        return header + '.' + payload + '.' + signature;
    }
}

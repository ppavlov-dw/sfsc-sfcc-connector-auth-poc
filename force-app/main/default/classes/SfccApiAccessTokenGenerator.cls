public with sharing class SfccApiAccessTokenGenerator implements Schedulable {
    @future(callout=true)
    private static void updateToken(String env) {
        new SfccAccessTokenMgr().updateAccessToken(env);
    }

    public void execute(SchedulableContext sc) {
        updateToken('dev');
    }
}

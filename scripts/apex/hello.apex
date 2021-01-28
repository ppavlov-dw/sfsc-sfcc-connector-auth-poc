// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// string tempvar = 'Enter_your_name_here';
// System.debug('Hello World!');
// System.debug('My name is ' + tempvar);

System.schedule('Update SFCC Access Tokens', '0 06 * * * ?', new SfccApiAccessTokenGenerator());
SfccApiTestCall.testCall();
new SfccAccessTokenMgr().updateAccessToken([SELECT Name, Realm__c, Client_ID__c, Scopes__c FROM SFCC_Environment__c WHERE Name = 'dev']);

ServiceConfiguration.configurations.remove({
    service: 'facebook'
});
 
ServiceConfiguration.configurations.insert({
    service: 'facebook',
    appId: Meteor.settings.facebookappid,
    secret: Meteor.settings.facebooksecret
});

ServiceConfiguration.configurations.remove({
    service: 'twitter'
});

ServiceConfiguration.configurations.insert({
    service: 'twitter',
    consumerKey: Meteor.settings.twitterapikey,
    secret: Meteor.settings.twittersecret
});

ServiceConfiguration.configurations.remove({
    service: 'google'
});

ServiceConfiguration.configurations.insert({
    service: 'google',
    clientId: Meteor.settings.googleapikey,
    secret: Meteor.settings.googlesecret
});
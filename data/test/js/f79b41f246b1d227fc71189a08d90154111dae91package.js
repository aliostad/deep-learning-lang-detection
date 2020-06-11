Package.describe({
  name: 'useful:email-mailgun',
  summary: 'Send and receive emails via mailgun',
  version: "0.0.3",
  git: 'git@github.com:usefulio/mailgun.git'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');
  
  api.use('cwohlman:emails@0.4.0');
  api.imply('cwohlman:emails');

  api.use('http');
  api.use('sha');
  api.use('iron:router');

  api.addFiles('mailgun-emails.js');

  api.export('Mailgun');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('useful:email-mailgun');
  api.use('iron:router');
  api.addFiles('mailgun-emails-tests.js');
});

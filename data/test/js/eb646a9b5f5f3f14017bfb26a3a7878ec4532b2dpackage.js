Package.describe({
  name: 'khamoud:linkedin-api',
  summary: ' Meteor wrapper for the linkedin api.',
  version: '1.0.0',
  git: 'https://github.com/krishamoud/meteor-linkedin-api'
});

Npm.depends({'node-linkedin': '0.3.4'});

Package.onUse(function(api) {
  api.versionsFrom('1.0.1');
  api.addFiles('khamoud:linkedin-api.js', 'server');
  api.export('Linkedin');

});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('khamoud:linkedin-api');
  api.addFiles('khamoud:linkedin-api-tests.js');
});

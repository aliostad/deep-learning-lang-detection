Package.describe({
  name: 'jss:coffeescript-decorators',
  version: '0.0.1',
  summary: '',
  git: 'https://github.com/JSSolutions/meteor-coffeescript-decorators',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use('coffeescript');
  api.addFiles('coffeescript-decorators.coffee');
});


Package.onTest(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use('tinytest');
  api.use('coffeescript');
  api.use('jss:coffeescript-decorators');
  api.addFiles('coffeescript-decorators-tests.coffee');
});
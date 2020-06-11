Package.describe({
  name: 'mantle:models',
  version: '0.0.1',
  summary: 'Models for mantle',
  git: ''
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use('coffeescript');
  api.use('jagi:astronomy@0.12.0');
  api.use('jagi:astronomy-validators@0.10.8');
  api.use('accounts-password');
  api.use('useraccounts:core@1.7.0');
  api.use('mongo');
  api.use('cfs:standard-packages');
  api.use('cfs:gridfs');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('coffeescript');
  api.use('mantle:models');
  api.use('practicalmeteor:munit');
  api.use('test-helpers');
});

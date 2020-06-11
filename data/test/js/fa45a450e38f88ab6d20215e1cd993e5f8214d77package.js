Package.describe({
  name: 'thomasvanlankveld:simeon',
  version: '0.1.1',
  summary: 'Access control for isomorphic javascript applications',
  git: 'https://github.com/thomasvanlankveld/simeon',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');
  api.use([
    'ecmascript',
    'underscore'
  ]);
  api.addFiles('simeon.js');
  api.export('simeon');
});

//Package.onTest(function(api) {
//    api.use('ecmascript');
//    api.use('tinytest');
//    api.use('thomasvanlankveld:simeon');
//    api.addFiles('simeon-tests.js');
//});

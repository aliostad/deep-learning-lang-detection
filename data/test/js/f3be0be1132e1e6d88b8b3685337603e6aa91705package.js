Package.describe({
  name: 'browserify:wordpress-rest-api',
  version: '0.5.0',
  summary: 'Browserify package for the npm package \'wordpress-rest-api\'',
  git: 'https://github.com/kadamwhite/wordpress-rest-api',
  documentation: null
});

Npm.depends({
  'wordpress-rest-api':'0.5.0'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');
  api.use('browserify:base@1.0.0', 'client');
  api.use('cosmos:browserify@0.8.0', 'client');
  api.addFiles('client.browserify.js', 'client');
  api.imply('browserify:base', 'client');
});

Package.describe({
  summary: "Wrapper for npm akismet-api",
  version: "1.0.0",
  git: "https://github.com/dfischer/akismet"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.0.1');

  api.use(['deps',
    'meteorhacks:async@1.0.0'
  ],'server');

  api.addFiles('dfischer:akismet.js', 'server');

  api.export('Akismet', 'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('dfischer:akismet');
  api.addFiles('dfischer:akismet-tests.js');
});

Npm.depends({
  "akismet-api": "1.1.3"
});

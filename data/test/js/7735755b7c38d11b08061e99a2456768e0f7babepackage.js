Package.describe({
  name: 'gandev:packages-analyzer',
  summary: "meteor package analyzer",
  version: "0.1.0",
  git: ""
});

Npm.depends({
  'esprima': '2.7.2',
  'escope': '3.6.0',
  'estraverse': '4.2.0'
});

Package.onUse(function(api) {
  api.versionsFrom('1.3');

  api.use('ecmascript');
  api.use('underscore');
  api.use('http');
  api.use('templating-tools');

  api.addFiles('analyzer.js', 'server');
  api.addFiles('github_data.js', 'server');

  api.export('Analyzer');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('analyzer');

  api.use('underscore');

  api.addFiles('analyzer-tests.js', 'server');
});

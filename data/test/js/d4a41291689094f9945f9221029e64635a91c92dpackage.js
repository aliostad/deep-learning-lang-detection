"use strict";

Package.describe({
  name: 'brettle:accounts-multiple',
  version: '0.3.1',
  summary: 'Handles users that login with multiple services.',
  git: 'https://github.com/brettle/meteor-accounts-multiple.git',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.4');
  api.use('underscore', 'server');
  api.use('ddp', 'server');
  api.use('brettle:workaround-issue-4862@0.0.1', 'server');
  api.addFiles('accounts-multiple-server.js', 'server');
  api.export('AccountsMultiple');
});

Package.onTest(function(api) {
  api.versionsFrom('1.0.4');
  api.use('brettle:accounts-multiple');
  api.use('brettle:accounts-testing-support');
  api.use('brettle:accounts-anonymous');
  api.use('tinytest');
  api.use('underscore');
  api.use('ddp');
  api.use('accounts-password');
  api.addFiles('accounts-multiple-server-tests.js', 'server');
});

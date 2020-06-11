Package.describe({
  name: 'ols:lib',
  version: '0.0.1',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');
  api.use(['jquery', 'templating', 'ecmascript', 'reactive-var', 'check', 'mongo', 'tracker', 'yuukan:streamy', 'mquandalle:stylus']);
  api.addFiles([
	  'namespace.js',
	  'error-api.js',
	  'timeutils-api.js',
	  'stringutils-api.js',
	  'context-api.js',
	  'project-api.js',
	  'board-api.js',
	  'message-api.js',
	  'activity-api.js',
	  'item-api.js',
	  'sub-item-api.js',
	  'user-api.js',
	  'router-api.js',
	  'filter-api.js',
	  'message-history-api.js',
	  'explore-api.js'
  ]);
  api.export(['Ols', 'Streamy']);
});

Package.onTest(function(api) {
  api.use('ecmascript');
  api.use('tinytest');
  api.use('ols:lib');
});

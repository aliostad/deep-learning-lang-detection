'use strict';
Package.describe({
	summary: 'Mailgun API - Mailgun api implementation for Meteor.',
	version: '1.1.0',
	git: 'https://github.com/gfk-ba/meteor-mailgun-api'
});

Npm.depends({
	'mailgun-js': '0.7.7',
	'mkdirp': '0.3.5'
});

Package.onUse(function(api) {
	api.versionsFrom('METEOR@1.0');

	api.add_files('mailgun-api.js', ['server']);

	api.export('Mailgun', ['server']);
});

Package.onTest(function (api) {
	api.use(['gfk:mailgun-api', 'tinytest', 'practicalmeteor:munit@2.1.2'], 'server');

	api.add_files('mailgun-api_tests.js', ['server']);
});

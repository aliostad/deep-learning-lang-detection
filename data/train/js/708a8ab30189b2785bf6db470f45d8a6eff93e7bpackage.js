Package.describe({
	name: 'jeanfredrik:fields',
	summary: 'Reactive inputs that update Mongo documents or ReactiveDicts (like Session) on edit',
	version: '0.1.0',
	git: 'https://github.com/jeanfredrik/meteor-fields.git'
});

Package.onUse(function(api) {
	api.versionsFrom('1.0');
	api.use('templating', 'client');
	api.use('reactive-dict', 'client');
	api.use('minimongo', 'client');
	api.use('underscore', 'client');

	api.addFiles('field.html', 'client');
	api.addFiles('field.js', 'client');

	api.addFiles('text-field.html', 'client');
	api.addFiles('text-field.js', 'client');

	api.addFiles('checkbox-field.html', 'client');
	api.addFiles('checkbox-field.js', 'client');

	api.export('Fields');
});

Package.onTest(function(api) {
	api.use('tinytest');
	api.use('jeanfredrik:fields');
	api.addFiles('tests.js');
});

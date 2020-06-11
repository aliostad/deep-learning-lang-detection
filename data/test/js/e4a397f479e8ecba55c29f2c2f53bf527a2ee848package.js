Package.describe({
	name: 'rocketchat:custom-oauth',
	summary: 'Custom OAuth flow',
	version: '1.0.0'
});

Package.onUse(function(api) {
	api.use('modules');
	api.use('check');
	api.use('oauth');
	api.use('oauth2');
	api.use('underscore');
	api.use('ecmascript');
	api.use('accounts-oauth');
	api.use('service-configuration');
	api.use('underscorestring:underscore.string');

	api.use('templating', 'client');

	api.use('http', 'server');


	api.mainModule('custom_oauth_client.js', 'client');

	api.mainModule('custom_oauth_server.js', 'server');

	api.export('CustomOAuth');
});

Package.describe({
    name: 'gfk:rest-api-base',
    summary: 'Base wrapper rest api for connect middleware',
    version: '0.1.7',
    git: 'https://github.com/gfk-ba/meteor-rest-api-base'
});

Package.onUse(function(api) {
    api.versionsFrom('1.0');
    api.use(['webapp', 'underscore'], 'server');
    api.addFiles('rest-api.js', 'server');
    api.export('RestApi');
});

Package.onTest(function(api) {
    api.use('tinytest', 'server');
    api.use(['gfk:rest-api-base', 'practicalmeteor:munit@2.1.2'], 'server');
    api.addFiles('rest-api.test.js', 'server');
});

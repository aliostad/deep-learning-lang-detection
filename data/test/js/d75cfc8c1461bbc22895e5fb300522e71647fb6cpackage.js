Package.describe({
    name: 'midoil:simple-schema',
    version: '0.0.1',
    summary: 'Opinionated wrapper of aldeed:simple-schema',
    git: 'https://github.com/midoil/meteor-simple-schema.git',
    documentation: 'README.md'
});

Package.onUse(function (api) {
    api.versionsFrom('1.2.0.2');
    api.use('ecmascript');
    api.use('underscore');
    api.use('midoil:modules@0.0.1');
    api.use('aldeed:simple-schema@1.3.3');
    api.addFiles('schema.js');
    api.imply('aldeed:simple-schema@1.3.3');
});

Package.onTest(function (api) {
    api.use('ecmascript');
    api.use('tinytest');
    api.use('midiol:simple-schema');
    api.addFiles('simple-schema-tests.js');
});

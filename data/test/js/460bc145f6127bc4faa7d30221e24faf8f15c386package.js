Package.describe({
    name: 'solitaire.findallsolutions',
    summary: ' Package that will find all solutions ',
    version: '1.0.0',
    git: ' /* Fill me in! */ '
});

Package.onUse(function (api) {
    api.versionsFrom('1.0.2.1');
    api.use('solitaire.core');
    api.addFiles('namespaces.js');
    api.export('SOLFINDALLSOLUTIONS', ['client', 'server']);
    api.addFiles(['lib/GameLauncher.js']);
});

Package.onTest(function (api) {
    api.use('tinytest');
    api.use('solitaire.core');
    api.use('solitaire.tools');
    api.addFiles('namespaces.js');
    api.addFiles(['lib/GameLauncher.js']);
    api.addFiles('solitaire.findallsolutions-tests.js')
});

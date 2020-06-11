
Package.describe({
    summary: 'Satellite: framework for Meteor in coffeescript.',
    version: '0.2.5',
    documentation: null
});

Package.on_use( function (api) {
    api.use('jquery@1.0.1');
    api.use('isaac:settings@0.1.9');
    api.use('isaac:absurd@0.0.2');
    api.use('isaac:intl-tel-input@0.1.3');
    api.use('isaac:route@0.1.2');
    api.use('isaac:masonry@0.0.1');
    api.use('isaac:moment@0.0.1');
    api.use('isaac:x@0.3.4');
    api.add_files( 'satellite.js', ['client', 'server'] );

    api.export( 'x',        ['client', 'server'] );    
    api.export( 'db',       ['client', 'server'] );
    api.export( 'Settings', ['client', 'server'] );
    api.export( 'Module',   ['client', 'server'] );
    api.export( 'module',   ['client', 'server'] );
});

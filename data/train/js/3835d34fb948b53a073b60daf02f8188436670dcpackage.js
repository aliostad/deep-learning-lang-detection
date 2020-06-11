
Package.describe({ summary: 'Satellite framework for Meteor.' });

Package.on_use( function (api) {
    api.use('underscore');
    api.use('jquery');
    api.use('isaac:masonry');
    api.use('isaac:moment');
    api.use('isaac:x');
    api.add_files( 'config.js', ['client', 'server'] );
    api.add_files( 'sat.js',    ['client', 'server'] );
//    api.add_files( 'callback.js',     'server' );

    api.export( '__',      ['client', 'server'] );    
    api.export( 'db',      ['client', 'server'] );
    api.export( 'Sat',     ['client', 'server'] );
    api.export( 'Pages',   ['client', 'server'] );
    api.export( 'Config',  ['client', 'server'] );
    api.export( 'module',  ['client', 'server'] );
});

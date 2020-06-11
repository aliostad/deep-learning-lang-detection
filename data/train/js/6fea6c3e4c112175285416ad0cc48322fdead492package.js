
Package.describe({ 
    summary: 'x tools',
    version: "0.3.8",
    documentation: null
});

Package.on_use( function (api) {
    api.use('http@1.1.0');
    api.use('isaac:settings@0.1.0');

    api.add_files( 'x_init.js',   ['client', 'server'] );
    api.add_files( 'x.js',        ['client', 'server'] );
    api.add_files( 'x_client.js',  'client' );
    api.add_files( 'methods.js', ['client', 'server'] );
    api.add_files( 'x_jquery.js', 'client' );
    api.export( 'x',        ['client', 'server'] );    
    api.export( 'db',       ['client', 'server'] );    
    api.export( 'Pages',    ['client', 'server'] );    
    api.export( 'Settings', ['client', 'server'] ); 
    api.export( 'exports',  ['client', 'server'] );    
});

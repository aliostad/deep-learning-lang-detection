/**
 * Varnish Service
 *
 */
require( '../docker-proxy' ).service( function serviceHandler( error, service ) {
  this.debug( 'Varnish Service' );

  service.auto({
    serviceReady: [ function serviceReady( next, state ) {
      service.debug( 'varnish', 'serviceReady' )
      service.once( 'ready', next );
    }],
    startVarnish: [ 'serviceReady', function startVarnish( next, state ) {
      service.debug( 'varnish', 'startVarnish' )
      service.log.info( 'Primary Docker Varnish service started' );
      next( null, {} );
    }],
    maintainBackends: [ 'startVarnish', function maintainBackends( next, state ) {
      service.debug( 'varnish', 'maintainBackends' )
      next( null );
    }]
  });

});

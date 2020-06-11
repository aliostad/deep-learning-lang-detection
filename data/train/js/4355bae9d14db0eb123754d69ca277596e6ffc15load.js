/* app/ui/nav/load */

define(
	[
		'jquery',
		'util/mediaqueries'
	],
	function( $, MediaQueries ) {

		var NavLoad;

		return {
			init: function() {
				NavLoad = this;

				NavLoad._initMediaQueries();
			},

			_initMediaQueries: function() {

				MediaQueries.register( [{
				//Bind Small Nav
					queries: MediaQueries.queries["megamenu--small"],
					shouldDegrade: false,
					match: function() {
						require( ['app/ui/nav/small'], function( NavSmall ) {
							NavSmall.init();
						} );
					},
					unmatch: function() {
						require( ['app/ui/nav/small'], function( NavSmall ) {
							NavSmall.unbind();
						} );
					}
				}, {
				//Bind Large Nav
					queries: MediaQueries.queries["megamenu--large"],
					shouldDegrade: true,
					match: function() {
						require( ['app/ui/nav/large'], function( NavLarge ) {
							NavLarge.init();
						} );
					},
					unmatch: function() {
						require( ['app/ui/nav/large'], function( NavLarge ) {
							NavLarge.unbind();
						} );
					}
				}] );
			}
		};

	}
);
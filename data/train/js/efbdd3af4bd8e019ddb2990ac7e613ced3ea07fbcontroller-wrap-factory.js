define( [ "barterModule", "jquery" ],
	function( barterModule ){
		barterModule.factory( "controllerWrap",
			function( ){
				return function controllerWrap( element, controller, callback ){
					if( !( element instanceof jQuery ) ){
						element = $( element );
					}
					var controllerElement = $( "<controller></controller>" )
						.attr( "ng-controller", controller );
					element.append( controllerElement );
					controllerElement.ready( function( ){
						callback( controllerElement ); 
					} );
				};
			} );
	} );
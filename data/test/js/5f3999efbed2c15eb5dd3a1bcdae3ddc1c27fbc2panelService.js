angular.module( 'plugin.panel' )
	.service( 'panelService', [
		'$q',
		'$log',
		'$rootScope',
		'eventsFabricService',
		'utilsService',
		'logService',
		function( $q, $log, $rootScope, eventsFabricService, utilsService, logService ){
			var
				instanceId,
				panelService = {};

			panelService.setInstanceId = _.once( function ( id ){
				instanceId = id;
				logService.addPrefix( 'i' + instanceId );
			} );
			panelService.destroy = function (){
				$log.info( 'destroy panel' );
				$rootScope.$emit( 'appDestroy' );
				eventsFabricService.destroy();
				utilsService.destroyTimers();
			};

			return panelService;
		}] );
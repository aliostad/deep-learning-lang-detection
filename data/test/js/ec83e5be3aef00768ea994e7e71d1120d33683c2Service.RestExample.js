resourceResolver.register.service(
	'RestExampleService', [
		'$rootScope', '$resource', 'APP_CONFIG', '$log',
		function($rootScope, $resource, APP_CONFIG, $log ) {
			var service = {
				_name: 'RestExampleService',
				apiDefinition: {
					path: APP_CONFIG.API_URI + 'path/:_id',
					params: {
						_id: '@_id'
					},
					actions: {
						'update': {
							method: 'PUT'
						}
					}
				}
			};

			/**
			 * Initialise Service
			 */

			service.init = function() {
				service.Item = $resource(service.apiDefinition.path, service.apiDefinition.params, service.apiDefinition.actions);
				service.items = [];
				service.getItems();
				return service;
			};

			service.getItem = function(_id) {
				return service.Item.get({_id: _id});
			};

			service.getItems = function() {
				service.items = service.Item.query();
			};

			return service.init(); // Return Service
		}
	]
);
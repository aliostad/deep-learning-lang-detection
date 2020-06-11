/**
 * Base Controller
 */
		//[ 'angular', 'controllers/NavigationController', 'controllers/HomeController', 'controllers/AboutController' ],

define([ 'angular', 'controllers/NavigationController', 'controllers/HomeController', 'controllers/AboutController' ],
		
		function(angular, NavigationController, HomeController, AboutController) {

			var controllers = angular.module('myApp.controllers',
					[ 'myApp.services' ]);

			controllers.controller('NavigationController',  ['$scope', '$location', NavigationController]);
			controllers.controller('HomeController',  ['$scope', '$route', HomeController]);
			controllers.controller('AboutController', ['$scope', '$route', AboutController]);

			return controllers;
		});
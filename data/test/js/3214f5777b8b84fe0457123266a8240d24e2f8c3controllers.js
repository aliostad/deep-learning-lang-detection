define([
        'angular',
        'app/js/services/services',
        'app/js/controllers/IndexController',
		'app/js/controllers/NavigationController',
		'app/js/controllers/HomeController'

        ], function(
        		angular,
        		services,
        		indexController,
				navigationController,
				homeController
        ){
	var controllers = angular.module('app.controllers', ['app.services']);
	
	//add controllers here
	controllers.controller('NavigationController', navigationController);
	controllers.controller('IndexController', indexController);
	controllers.controller('HomeController', homeController);
	
	
	return controllers;
});
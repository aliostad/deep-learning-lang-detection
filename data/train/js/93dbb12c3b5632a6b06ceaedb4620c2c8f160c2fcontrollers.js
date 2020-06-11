define([
	'angular',
	'application/js/services/services',
	'application/js/controllers/IndexController',
	'application/js/controllers/NavigationController',
	'application/js/controllers/HomeController'
	], 
	function(
		angular,
		services,
		indexController,
		navigationController,
		homeController
	){
		var controllers = angular.module('application.controllers', ['application.services']);
		
		//add controllers here
		controllers.controller('NavigationController', navigationController);
		controllers.controller('IndexController', indexController);
		
		controllers.controller('HomeController', homeController);
		
		
		return controllers;
});
angular.module('tippspiel.config')
	.config(['$routeProvider', function ($routeProvider) {
	    $routeProvider
	        .when('/',
	        {
	            controller: 'homeController',
	            templateUrl: '/templates/welcome'
	        })
	        .when('/game',
	        {
	            controller: 'gameController',
	            templateUrl: '/templates/game'
	        })
	        .when('/rules',
	        {
	            controller: 'rulesController',
	            templateUrl: '/templates/rules'
	        })
			.when('/admin',
	        {
	        	controller: 'adminController',
	        	templateUrl: '/templates/admin'
	        })
	        .when('/edit/:customerId',
	        {
	            controller: 'HomeController',
	            templateUrl: '/templates/edit'
	        })
	        .otherwise({ redirectTo: '/' });
}]);
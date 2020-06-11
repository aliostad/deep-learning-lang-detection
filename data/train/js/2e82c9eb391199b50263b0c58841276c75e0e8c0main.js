// create module
var fplApp = angular.module('fplApp', ['ngRoute']);

fplApp.config(function($routeProvider) {
	$routeProvider

		// Home
		.when('/', {
			templateUrl : 'pages/home.html',
			controller  : 'homeController'
		})

		.when('/history', {
			templateUrl : 'pages/history.html',
			controller  : 'historyController'
		})

		.when('/records', {
			templateUrl : 'pages/records.html',
			controller  : 'recordsController'
		})

		.when('/season', {
			templateUrl : 'pages/season.html',
			controller  : 'seasonController'
		})

		.when('/clubs', {
			templateUrl : 'pages/clubs.html',
			controller  : 'clubsController'
		})
});

/* these don't do anything yet */
fplApp.controller('homeController', function($scope) {

})

fplApp.controller('historyController', function($scope) {

})

fplApp.controller('recordsController', function($scope){

})

fplApp.controller('seasonController', function($scope) {

})

fplApp.controller('clubsController', function($scope){

})
var taleslide = angular.module("taleslide", []).config(function($routeProvider) {
	$routeProvider.when('/', {
		templateUrl: 'tmpl/home.html',
		controller: 'HomeController'
	});
	$routeProvider.when('/GetStarted', {
		templateUrl: 'tmpl/getstarted.html',
		controller: 'GetStartedController'
	});
	$routeProvider.when('/OurStory', {
		templateUrl: 'tmpl/ourstory.html',
		controller: 'OurStoryController'
	});
	$routeProvider.when('/BeRemarkable', {
		templateUrl: 'tmpl/beremarkable.html',
		controller: 'BeRemarkableController'
	});
	$routeProvider.when('/LearnMore', {
		templateUrl: 'tmpl/learnmore.html',
		controller: 'LearnMoreController'
	});

	$routeProvider.otherwise({ redirectTo: '/'});
});


// CONTROLLERS

taleslide.controller('HomeController', function() {

});

taleslide.controller('GetStartedController', function() {

});

taleslide.controller('OurStoryController', function() {

});

taleslide.controller('BeRemarkableController', function() {

});

taleslide.controller('LearnMoreController', function() {

});

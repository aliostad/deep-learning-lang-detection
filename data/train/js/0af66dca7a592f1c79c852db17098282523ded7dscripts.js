var markPageApp = angular.module('markPageApp', []);

markPageApp.config(function ($routeProvider) {
	$routeProvider
		.when ('/home',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Home.html'
			})
		.when ('/work',
			{
				controller: 'LoadingController',
				templateUrl:'partials/WorkHistory.html'
			})
		.when ('/education',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Education.html'
			})
		.when ('/projects',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Projects.html'
			})
		.when ('/contact',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Contact.html'
			})
		.when ('/disney',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Work/Disney.html'
			})
		.when ('/dragon',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Work/Dragon.html'
			})
		.when ('/toys',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Work/ThinkerToys.html'
			})
		.when ('/stormdrain',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Work/Stormdrain.html'
			})
		.when ('/hthi',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Education/HTHI.html'
			})
		.when ('/ucsc',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Education/UCSC.html'
			})
		.when ('/firewall',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Education/UCSC/Firewall.html'
			})
		.when ('/minigolf',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Education/UCSC/Minigolf.html'
			})
		.when ('/sustain',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Education/UCSC/Sustain.html'
			})
		.when ('/udk',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Education/UCSC/UDK.html'
			})
		.when ('/robots',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Projects/FIRST.html'
			})
		.when ('/firefighter',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Projects/Firefighter.html'
			})
		.when ('/gamejams',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Projects/GameJams.html'
			})
		.when ('/keystoke',
			{
				controller: 'LoadingController',
				templateUrl:'partials/Work/Keystoke.html'
			})
		.otherwise({redirectTo: '/home' });
});

markPageApp.controller('LoadingController', function($scope) {
	$scope.stuff = "Things?";
});

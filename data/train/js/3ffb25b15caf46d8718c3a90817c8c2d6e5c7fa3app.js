angular.module('Dashboard', []).config(function($routeProvider) {
	$routeProvider.when('/git', {
		templateUrl : 'views/git.html',
		controller : 'GitController'
	}).when('/svn', {
		templateUrl : 'views/svn.html',
		controller : 'SvnController'
	}).when('/jenkins', {
		templateUrl : 'views/jenkins.html',
		controller : 'JenkinsController'
	}).when('/redmine', {
		templateUrl : 'views/redmine.html',
		controller : 'RedmineController'
	}).when('/bbox', {
		templateUrl : 'views/bbox.html',
		controller : 'BBoxController'
	}).otherwise({
		redirectTo : '/bbox'
	});
});

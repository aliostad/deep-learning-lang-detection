var app = angular.module('app', []);

app.config(function($routeProvider){
	$routeProvider
	.when('/',{
		templateUrl: 'app.html',
		controller: 'AppController'
	})
	.when('/detail', {
		templateUrl: 'partials/detail.html',
		controller: 'DetailController'
	})
	.when('/add',{
		templateUrl: 'partials/add.html',
		controller: 'AddController'
	})
	.when('/edit', {
		templateUrl: 'partials/edit.html',
		controller: 'EditController'
	})
	.when('/delete',{
		templateUrl: 'partials/delete.html',
		controller: 'DeleteController'
	});
});
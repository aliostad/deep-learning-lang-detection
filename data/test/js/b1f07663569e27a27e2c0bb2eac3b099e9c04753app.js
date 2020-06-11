define(['angular',
	'controller/blogController',
	'controller/postController',
	'controller/indexController',
	'controller/resumeController',
	'controller/projectsController',
	'service/blogService',
	,'angular-route'
	,'angular-resource'
	,'angular-sanitize'],function(angular,blogctrl,postctrl,indexCtrl,resumeCtrl,projectsCtrl,blogSrv){
	var app= angular.module('app',['ngRoute','ngResource','ngSanitize']);
	var path='/app/';
	app.config(['$routeProvider','$locationProvider',function($routeProvider,$locationProvider){
		$routeProvider.when('/',{
				templateUrl:path+'view/index.html',
				controller:'indexController'
			})
		.when('/blog/post/:url',{
			templateUrl:path+'view/post.html',
			controller:'postController'
		})
		.when('/resume',{
			templateUrl:path+'view/resume.html',
			controller:'resumeController'
		})
		.when('/projects',{
			templateUrl:path+'view/projects.html',
			controller:'projectsController'
		})
		.otherwise({
        redirectTo: '/'
      });
	}]);
	app.service('blogService',['$http',blogSrv]);
	app.controller('postController',['$scope','blogService','$routeParams','$sce',postctrl]);
	app.controller('indexController',['$scope','blogService',indexCtrl]);
	app.controller('resumeController',['$scope',resumeCtrl]);
	app.controller('projectsController',['$scope',projectsCtrl]);
	return app;
});

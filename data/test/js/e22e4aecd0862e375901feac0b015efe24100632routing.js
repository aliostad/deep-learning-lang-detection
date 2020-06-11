var app = angular.module('routing', ['ngRoute'])

.config(function ($routeProvider){
	$routeProvider.when('/home', {
		controller: 'homeController',
		templateUrl: 'home.tpl.html'
	})
	.when('/about', {
		controller: 'aboutController',
		templateUrl: 'about.tpl.html'
	})
	.when('/whyilove', {
		controller: 'utahController',
		templateUrl: 'utah.tpl.html'
	})
	.otherwise({
		redirectTo: '/home'
	})

})

.controller('homeController', function($scope){
	
})


.controller('aboutController', function($scope){
	
})


.controller('utahController', function($scope){
	
});
var myApp = angular.module('myapp');

app.config(function($routeProvider) {
	$routeProvider.when('/', {
		templateUrl: 'templates/index.html',
		controller: 'MainController'
	})
	.when('/about', {
		templateUrl: 'templates/about.html',
		controller: 'AboutController'
	})
	.when('/portfolio', {
		templateUrl: 'templates/portfolio.html',
		controller: 'PortfolioController'
	})
	.when('/resume', {
		templateUrl: 'templates/resume.html',
		controller: 'ResumeController'
	})
	.when('/contact', {
		templateUrl: 'templates/contact.html'
		controller: 'ContactController'
	})
	.otherwise({ redirecTo: '/' });
});

app.controller('MainController', function(){

});

app.controller('AboutController', function(){

});

app.controller('PortfolioController', function(){

});

app.controller('ResumeController', function(){

});

app.controller('ContactController', function(){

});
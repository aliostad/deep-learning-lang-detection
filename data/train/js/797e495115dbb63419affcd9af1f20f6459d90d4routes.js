'use strict';
Application.config([
	'$routeProvider',
	function ($routeProvider) {
		$routeProvider
			.when('/', {controller: 'BoardsController', templateUrl: 'partials/boards.html'})
			.when('/board/:id', {controller: 'LinesController', templateUrl: 'partials/lines.html'})
			.when('/register', {controller: 'RegisterController', templateUrl: 'partials/login.html'})
			.when('/login', {controller: 'LoginController', templateUrl: 'partials/login.html'})
			.when('/logout', {controller: 'LogoutController', templateUrl: 'partials/login.html'})
			.otherwise({redirectTo: '/'});
	}
]);
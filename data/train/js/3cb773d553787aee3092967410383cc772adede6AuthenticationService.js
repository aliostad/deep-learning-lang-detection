angular.module( 'AuthenticationService', ['ngResource', 'SessionService'] )

.factory('AuthenticationService', function($http, SessionService) {
	var authService = {};
	 
	authService.login = function (credentials) {
		return $http
			.post('/api/login', credentials)
			.then(function (loginResponse) {
				SessionService.create(loginResponse.data.token, credentials.email, "Admin");
				return loginResponse;
			});
	};

	authService.logOff = function () {
		SessionService.destroy();
	};
	 
	authService.isAuthenticated = function () {
		return !!SessionService.token;
	};

	authService.getCurrentUser = function () {
		return SessionService.getCurrentUser();
	};
	 
	authService.isAuthorized = function (authorizedRoles) {
		if (!angular.isArray(authorizedRoles)) {
			authorizedRoles = [authorizedRoles];
		}
		return (authService.isAuthenticated() && authorizedRoles.indexOf(SessionService.userRole) !== -1);
	};
	 
	return authService;
});  



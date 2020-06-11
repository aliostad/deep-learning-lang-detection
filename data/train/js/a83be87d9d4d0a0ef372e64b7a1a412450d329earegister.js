angular.module('app').controller('AccountRegisterCtrl', ['$scope', '$location', 'AccountService', 'TokenService', 'AuthService',   function($scope, $location, AccountService, TokenService, AuthService){
	$scope.errors = [];
	$scope.register = function(){

		AccountService.register($scope.user)
		.then(function(data){
			TokenService.setToken(data.token);
			AuthService.setUsername(data.username);
			AuthService.setId(data._id);
			$location.path('/');
		},function(data){
			$scope.errors = data;
		});

	};

}]);
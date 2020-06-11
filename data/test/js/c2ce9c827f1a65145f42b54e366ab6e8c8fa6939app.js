angular.module('app', [])
	.controller('AppController', ['$scope', 'emailService',function($scope,emailService){
		
		$scope.get = function(){
			$scope.email = emailService.get();
		}

		$scope.save = function(){
			emailService.set($scope.email);
		}
		
	}])
	.controller('AppController2', ['$scope', 'emailService',function($scope,emailService){
		
		$scope.get = function(){
			$scope.email = emailService.get();
		}

		$scope.save = function(){
			emailService.set($scope.email);
		}
		
	}])
	.factory('emailService', function(){
		
		var emailService = {};
		var email = "";

		emailService.get = function(){
			return email;
		}
		emailService.set = function(value){
			email = value;
		}

		return emailService;
	})
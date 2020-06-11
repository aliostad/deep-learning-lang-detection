angular.module('appControllerModule',[]).
	controller('AppControllerOne',['$scope', 'messageServiceOne',function($scope, messageServiceOne) {
		$scope.message = '';
		$scope.showMessage = function() {
			$scope.message = messageServiceOne.sayHello;
		};
	}]).
	controller('AppControllerTwo',['$scope', 'messageServiceTwo',function($scope, messageServiceTwo) {
		$scope.message = '';
		$scope.showMessage = function() {
			$scope.message = messageServiceTwo.sayHello;
		};
	}]).
	controller('AppControllerThree',['$scope', 'messageServiceThree',function($scope, messageServiceThree) {
		$scope.message = '';
		$scope.showMessage = function() {
			$scope.message = messageServiceThree.sayHello;
		};
	}]);

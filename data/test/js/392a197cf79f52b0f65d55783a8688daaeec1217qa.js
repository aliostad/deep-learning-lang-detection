'use strict';

angular.module('mainApp')
.controller('QACtrl', ['$scope', '$controller', function ($scope, $controller) {

	$controller('MainCtrl', {$scope: $scope});
}])

	/**
	 * Sub-Controller
	 * ---------------------------------------------------------------------------------
	 */

	.controller('QAManager', ['$scope', '$controller', function ($scope, $controller) {


		// inherit functions from parent
		$controller('QACtrl', {$scope: $scope});

	}])
	.controller('List', ['$scope', '$controller', function ($scope, $controller) {



		// inherit functions from parent
		$controller('QAManager', {$scope: $scope});

	}]);

angular.module('test-runner', []).controller("MainCtrl", ['$scope', function ($scope) {
	$scope.notifications = {
		showPass: true,
		showFail: true
	};

	// Initialization
	(function () {
		chrome.storage.local.get(function (data) {
			$scope.notifications.showPass = data.showPass;
			$scope.notifications.showFail = data.showFail;
			apply();
		});
	})();

	$scope.onPassChange = function() {
		chrome.storage.local.set({showPass: $scope.notifications.showPass});
	};

	$scope.onFailChange = function() {
		chrome.storage.local.set({showFail: $scope.notifications.showFail});
	};

	function apply() {
		if( !$scope.$$phase ) {
			$scope.$apply();
		}
	}
}]);
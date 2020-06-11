topicnet.controllers.controller('AlertController', function($scope) {

	$scope.$on('error', function(e, message) {
		showAlert(message, 'error');
	});

	$scope.$on('success', function(e, message) {
		showAlert(message, 'success');
	});

	$scope.$on('info', function(e, message) {
		showAlert(message, 'info');
	});

	function showAlert(message, type) {
		$scope.message = message;
		$scope.type = type;
		setTimeout(function() {
			if($scope.message === message) {
				$scope.message = null;
				$scope.$apply();
			}
		}, 3000);
	}

});

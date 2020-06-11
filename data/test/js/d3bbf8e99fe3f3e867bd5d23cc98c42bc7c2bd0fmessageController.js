hoard.controller('messageController',function($scope, messageService) {
	$scope.successMessage = null;
	$scope.errorMessage = null;
	
	$scope.$watch(function() {
					return messageService.getMessages().errorMessage;
				},
				function() {
					$scope.errorMessage = messageService.getMessages().errorMessage;
				});
				
	$scope.$watch(function() {
					return messageService.getMessages().successMessage;
				},
				function() {
					$scope.successMessage = messageService.getMessages().successMessage;
				});
				
	$scope.close = function(type) {
		if(type == 'error')
			messageService.setError(null);
		else if(type = 'success')
			messageService.setSuccess(null);
	}
});
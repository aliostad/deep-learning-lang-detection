function MessageController($scope, MessageFactory, $log) {
	// when loading controller, initialize customer list from customerFactory
	init();
	
	function init() {
		$scope.messageStyle = "noDisplay";
		$scope.message = "No message available";		
	}

	$scope.$on('handleMessage', function() {
		$scope.message = MessageFactory.sharedMessage;
		$scope.messageStyle = MessageFactory.messageStyle;
		
		$scope.startTimer();
	});
	
	$scope.$on('timer-stopped', function (event, data){
		$scope.$apply(function() {
			$scope.message = "No message available";
			$scope.messageStyle = "noDisplay";	
		});
    });
    
    $scope.startTimer = function (){
		$scope.$broadcast('timer-start');
        $scope.timerRunning = true;
    };
}


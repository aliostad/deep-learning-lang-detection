function ChatController($scope) {
    var socket = io.connect('http://localhost:8080');    

    $scope.messages = [];

    $scope.send_message = function() {
	    var message = $scope.create_message_object($scope.message)
	    socket.emit('send_message', message);
	    $scope.messages.push(message);
	    $scope.message = '';
    };

	$scope.create_message_object = function(message_text) {
		message = {text: message_text};
		return message;
	};

	socket.on('new_message', function(data) {
		$scope.messages.push(data);
		$scope.$apply();
	});  
};

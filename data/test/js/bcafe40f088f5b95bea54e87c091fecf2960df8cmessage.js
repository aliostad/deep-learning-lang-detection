app.controller('message', ['$scope', 'close', 'messageService', function($scope, close, messageService) {
  $scope.display = true;
  $scope.subject = 'Enter a subject...';
  $scope.message = 'Enter a message here..';
  $scope.cancelSend = function(){
  	close();
  };
  $scope.sendMessage = function(){
  	var id = messageService.getReceiverId();
  	var message = {};
  	message.subject = $scope.subject;
  	message.message = $scope.message;
  	messageService.sendMessage(id, message).then(function(updated){
      if(updated === 'true'){
        swal("Sent!", "Your message was successfully sent.", "success");
        close();
      } else {
        swal("Oops...", "Something bad happened. Try again!", "error");
        close();
      }
  	});
  };
}]);
'use strict'

app.config(function($stateProvider){
  $stateProvider.state('messageCompose', {
    url: '/messageCompose',
    templateUrl: 'js/message/sendMessage.html',
    controller: 'MessageComposeController'
  });
});

app.controller('MessageComposeController', function($modalInstance, $scope, $state, Message){
  $scope.message = {
    recipient : {
      email: null
    }
  };
  if(Message.currentRecipient.email) $scope.message.recipient.email = Message.currentRecipient.email;
  $scope.sendMessage = function(message) {
    Message.sendMessage(message).then(function(){
      $state.go('message');
      $modalInstance.close();
    })
  };
});
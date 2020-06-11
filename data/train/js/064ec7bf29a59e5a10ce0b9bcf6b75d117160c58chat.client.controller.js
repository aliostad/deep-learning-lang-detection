angular.module('chat').controller('ChatController', ['$scope', 'Socket', function($scope, Socket){
  $scope.messages = [];
  Socket.on('chatMessage', function(message){
    console.log("chatMessage: " + message.text);
    $scope.messages.push(message);
  });
  $scope.sendMessage = function(){
    var message = {
      text: this.messageText
    };
    Socket.emit('chatMessage', message);
    this.messageText = '';
  };

  $scope.$on('$destory', function(){
    Socket.removeListner('chatMessage');
  });
}]);
                                                     

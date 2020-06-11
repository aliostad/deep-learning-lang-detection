angular.module('dreamChatApp').controller("RoomsController", function ($scope, socket) {
    $scope.newMessage = "";
    $scope.messageList = [];
    $scope.sendMessage = function () {
        socket.emit('createMessage', $scope.newMessage);
        $scope.newMessage = "";
    };
    socket.emit('getAllMessage');
    socket.on('allMessage', function (messageList) {
        $scope.messageList = messageList;
    });
    socket.on('message', function (message) {
        console.log("message:" + message);
        $scope.messageList.push(message);
    });
});
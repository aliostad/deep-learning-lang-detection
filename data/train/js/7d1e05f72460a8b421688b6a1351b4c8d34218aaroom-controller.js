angular.module('dreamChatApp').controller("RoomController", function ($scope, socket) {

    $scope.newMessage = "";
    $scope.messageList = [];
    $scope.userList = [];
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
    socket.emit("getAllUser");
    socket.on("allUser", function (userList) {
        $scope.userList = userList;
    });
});
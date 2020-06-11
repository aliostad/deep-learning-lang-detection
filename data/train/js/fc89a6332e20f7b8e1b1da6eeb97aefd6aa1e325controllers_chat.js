'use strict';

function SendChatMessage (socket, message, username){
    if (message === "" || message === undefined){
        return;
    }
    socket.send(JSON.stringify(
        {"message": message
         ,"username": username
         ,"type": "chat" }));
}


function ChatCtrl($scope, socket){
    $scope.messageList = [];
    $scope.sendMessage = function() {
        SendChatMessage(socket, $scope.message, $scope.currentUser);
        $scope.message = "";
    }
    socket.on(function(event){
        console.log('received : ', JSON.parse(event.data));
        var message = JSON.parse(event.data);
        if (message.type === "chat"){
            $scope.messageList.push({
                "user": message.username
                ,"message": message.message});
        }
    });
}
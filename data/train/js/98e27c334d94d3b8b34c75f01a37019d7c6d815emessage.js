'use strict';
Application.Directives.directive('message',function() {
    return {
        restrict: 'E',
        templateUrl: 'app/message/message.html',
        replace: true,
        scope: {},
        controller: function($scope,Message) {
            $scope.message = Message.init();
            $scope.clearMessage = Message.clear;
        },
        link: function(scope,element,attrs) {
            
        }
    }
});

Application.Services.factory('Message',function() {
    var message;
    return {
        set: function(msg) { 
            message.text = msg.text; message.kudos = msg.kudos; message.type = msg.type ? msg.type : 'default'; 
        },
        clear: function() { delete message.text; delete message.kudos; delete message.type; },
        init: function() { message = { }; return message; }
    };
});
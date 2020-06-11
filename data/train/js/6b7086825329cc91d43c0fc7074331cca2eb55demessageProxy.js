(function () {
    'use strict';

    angular
        .module('app')
        .factory('messageProxy', messageProxy);

    messageProxy.$inject = ['$rootScope'];

    function messageProxy($rootScope) {
        
        var messageHub = $.connection.messageHub;

        var service = {
        };

        init();
        return service;

        function init() {
            startConnection();
            onRecieveMessage();
        }

        function startConnection() {
            $.connection.hub.start().done(function () {
                $rootScope.$broadcast('MESSAGE_CONNECTION_STARTED', { data: 'Started' });
            });
        }

        function onRecieveMessage() {
            messageHub.client.messageRecieved = function (message) {
                console.log(message.Message);
                var data = { message: message };
                $rootScope.$broadcast('MESSAGE_RECEIVED', data);
                $rootScope.$apply();
            };
        }
    }
})();
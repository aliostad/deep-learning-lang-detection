(function() {

    'use strict';

    angular
        .module('authApp')
        .factory('MessageService', MessageService);

    function MessageService() {
        var message = '';
        var error = '';

        var MessageService = {};

        MessageService.setMessage = function(newMessage) {
            message = newMessage;
        };

        MessageService.getMessage = function() {
            var returnMessage = message;
            message = '';
            return returnMessage;
        };

        MessageService.setError = function(newError) {
            error = newError;
        };

        MessageService.getError = function() {
            var returnError = error;
            error = '';
            return returnError;
        };

        return MessageService;
    }

})();
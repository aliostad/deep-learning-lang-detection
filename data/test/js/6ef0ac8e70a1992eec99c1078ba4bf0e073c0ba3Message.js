'use strict';
define(function(require, exports) {

var messageTemplate = require("./templates/message.html");

angular.module('gymMessage', [])
.factory("MessageService", function() {
    var items = [];
    return {
        all: function() {
          return items;
        },
        create: function() {
          items.push(arguments[0]);
        }
    };
})
.controller('MessageController', ['$scope', '$filter', '$timeout', 'MessageService', function ($scope, $filter, $timeout, MessageService) {
    $scope.message = {};
    $scope.message.total = 0;
    $scope.message.msgs = [];
    $scope.message.currents = [];
    $scope.message.current = null;

    // show the message
    $scope.message.show = function(message) {
        message.id = (new Date()).getTime();
        message.date = $filter('date')(message.id, 'HH:mm:ss');

        $scope.message.current = message;

        $scope.message.currents.push(message);
        $scope.message.msgs.push(message);
        MessageService.create(message);

        $timeout(function() {
            $(document.body).removeClass("msging");
            $scope.message.close();
        }, 5000);
    };
    // close the message
    $scope.message.close = function() {
        $scope.message.currents.pop();
        if ($scope.message.currents.length > 0) {
            $scope.message.current = $scope.message.currents[$scope.message.currents.length - 1];
        }
    };
    $scope.message.closeAll = function() {
        $(document.body).removeClass("msging");
        $scope.message.currents = [];
        $scope.message.current = null;
    };
    // show a success message
    $scope.message.success = function(msg) {
        var message = {
            type: 'success',
            text: msg,
            show: true
        };
        $scope.message.show(message);
    };
    // show a info message
    $scope.message.info = function(msg) {
        var message = {
            type: 'info',
            text: msg,
            show: true
        };
        $scope.message.show(message);
    };
    // show a error message
    $scope.message.error = function(msg) {
        var message = {
            type: 'error',
            text: msg,
            show: true
        };
        $scope.message.show(message);
    };
    // show a warn message
    $scope.message.warn = function(msg) {
        var message = {
            type: 'block',
            text: msg,
            show: true
        };
        $scope.message.show(message);
    };
    
    /*
    $scope.message.success('success');
    $scope.message.info('info');
    $scope.message.error('error');
    $scope.message.warn('warn');
    */
    
}])
.directive("gymMessage", ['$location', function ($location) {
    return {
        restrict: 'A',
        replace: true,
        template: messageTemplate,
        controller: "MessageController",
        link: function ($scope, $element, $attrs) {
        }
    };
}]);

});
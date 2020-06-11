angular.module('messageCenter', []).
factory('messageService', function ($rootScope) {
    var messageCenter = {};
    messageCenter.counter = 0;
    messageCenter.messageItems = [];

    messageCenter.prepForBroadcast = function (msg) {
        this.counter++;
        var messageItem = {};
        messageItem.message = msg;
        messageItem.id = this.counter;
        this.messageItems.push(messageItem);
        this.broadcastItem();
    };

    messageCenter.broadcastItem = function () {
        $rootScope.$broadcast('handleBroadcast');
    };

    messageCenter.removeItem = function (messageItem) {
        this.messageItems.splice(messageItem, 1);
    };

    return messageCenter;
}).
directive('messageCenter', function (messageService) {
    return {
        restrict: 'E',
        scope: {},
        template: '<message ng-repeat="messageItem in messageItems"></message>',
        controller: function ($scope, $attrs, messageService) {
            $scope.$on('handleBroadcast', function () {
                $scope.messageItems = messageService.messageItems;
            });
        }
    };
}).
directive('message', function (messageService) {
    return {
        replace: true,
        restrict: 'E',
        templateUrl: 'modules/message-center/partials/message-box.html',
        link: function (scope, element, attrs) {
            setTimeout(function(){
                messageService.removeItem(scope.messageItem);
                scope.$apply();
            }, 2700)
        }
    };
});
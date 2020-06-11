angular.module('messageView')
    .controller('MessageViewController', ['$scope', 'messageService', function ($scope, messageService) {
        $scope.messages = messageService.getMessages();

        $scope.removeMessage = function(message) {
            messageService.removeMessage(message);
        };

        $scope.$watch(
            function () {
                return messageService.getMessages();
            },
            function () {
                $scope.messages = messageService.getMessages();
            }
        );
    }]);
(function() {

    var MessageCtrl = function($scope, MessageService) {
        $scope.message = {};

        // Load all messages
        MessageService.all().then(function(messages) {
            $scope.messages = messages.data;
        });

        // Create a new message
        $scope.newMessage = function() {
            if (! $scope.messageForm.$valid) {
                return false;
            }

            MessageService.create($scope.message).then(function(response) {
                // Reset the form
                $scope.message = {};
                $scope.messageForm.$setPristine();

                // Push new message into scope
                $scope.messages.unshift(response.data.data);
            });
        };
    };

    MessageCtrl.$inject = ['$scope', 'MessageService'];

    angular.module('guestbook').controller('MessageCtrl', MessageCtrl);

})();

var MessageCtrl = function ($scope, messageService) {
    $scope.$watch(function () { return messageService.isShowing(); }, function (value) {
        $scope.Title = messageService.messageOptions.title;
        $scope.AlertType = messageService.messageOptions.alertType;
        $scope.Message = messageService.messageOptions.message;
        $scope.showMessage = value;
    });
    $scope.close = function () {
        messageService.closeMessage();
    };
};
MessageCtrl.$inject = ['$scope', 'messageService'];
function demoMessageController($scope, $location, $rootScope, $http) {

    $scope.Status = '';
    $http.get('Demo/GetMessage').success(function (data) {
        $scope.Message = data;
    });
    
    $scope.Send = function () {
        
        $scope.MessageStatus = 'Message Sending...';
        $http({
            url: 'Demo/SetMessage',
            method: "POST",
            data: { 'message': $scope.Message }
        }).success(function (data, status, headers, config) {
            $rootScope.MessageSendResult = data;
            $location.path('/MessageSended');           
            //$scope.Message.Text = '';
            //$scope.MessageStatus = 'Message Sended';
        }).error(function() {
            $scope.MessageStatus = 'Message Not Sended';
        });
    };
    
    $scope.GoConfig = function () {
        $location.path('/MessageConfig');
    };

}

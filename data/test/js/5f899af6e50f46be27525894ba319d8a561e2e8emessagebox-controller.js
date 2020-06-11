'use strict';

angular.module("DivinElegy.components.messages", [])

.controller("MessageBoxController", ['$scope', function($scope)
{
    //message types are info, success, warning, error
    
    $scope.message = '';
    $scope.messageType = 'info';
    $scope.hidden = true;
        
    $scope.hide = function()
    {
        $scope.hidden = true;
    };
    
    $scope.$on('message.error', function(event, message)
    {
        $scope.message = message;
        $scope.messageType = 'error';
        $scope.hidden = false;
    });
    
    $scope.$on('message.info', function(event, message)
    {
        $scope.message = message;
        $scope.messageType = 'info';
        $scope.hidden = false;
    });
    
    $scope.$on('message.success', function(event, message)
    {
        $scope.message = message;
        $scope.messageType = 'success';
        $scope.hidden = false;
    });
    
    $scope.$on('message.warning', function(event, message)
    {
        $scope.message = message;
        $scope.messageType = 'warning';
        $scope.hidden = false;
    });
}]);
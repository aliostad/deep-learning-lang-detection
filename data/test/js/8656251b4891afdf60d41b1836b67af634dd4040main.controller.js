'use strict';

angular.module('menuApp')
  .controller('MainCtrl', function ($scope, $http, mySocket, configuration, $timeout, $q) {
    var prom;
    $scope.message = {
      messageShow: false,
      message: false,
    };

    //console.log(configuration.foo);
    mySocket.on('message', function (data) {
      $scope.setMessage(data.message);
      //mySocket.emit('my other event', { my: 'data' });
    });

    $scope.setMessage = function(message) {
      if (!$scope.message.messageShow && !$scope.message.message) {
        $scope.message.message = message;
        $scope.message.messageShow = true;
        $timeout(function() {
          $scope.message.messageShow = false;
          $timeout(function() {
            $scope.message.message = false;
          }, 200);
        }, 2000);
      }
    }

  })

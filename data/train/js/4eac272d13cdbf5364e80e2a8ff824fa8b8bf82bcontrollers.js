'use strict';

/* Controllers */

angular.module('txiRushApp.controllers', [])
  /*----------------------------Info Controller---------------------------*/
  .controller('infoController', ['$scope', function($scope) {
        $scope.pageName = "Info";
  }])
  /*--------------------------Driving Controller--------------------------*/
  .controller('drivingController', ['$scope', function($scope) {
        $scope.pageName = "Driving";
  }])
  /*-------------------------Coordinator Controller------------------------*/
  .controller('coordinateController', ['$scope', function($scope) {
        $scope.pageName = "Coordinator Mode";
  }])
  /*--------------------------Settings Controller--------------------------*/
  .controller('settingsController', ['$scope', function($scope) {
        $scope.pageName = "Settings";
  }]);

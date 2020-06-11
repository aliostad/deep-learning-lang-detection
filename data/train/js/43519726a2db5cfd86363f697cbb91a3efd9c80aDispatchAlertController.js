'use strict';

angular.module('vsko.stock').controller('DispatchAlertCtrl', ['$scope', '$rootScope', '$translate', '$location', 'Utils', 'Users', 'userRoles',
                                                             function ($scope, $rootScope, $translate, $location, Utils, Users, userRoles) {

  $scope.hideAlert = true;

  function checkForNewDispatch() {

    Users.existsNewDispatch($rootScope.user).then(function(result) {

      if (result.data.existsNewDispatch == '1') {
        $scope.hideAlert = false;
        $translate('Dispatch alert', {dispatchNumber: result.data.number}).then(function(value) {
          $scope.message = value;
        });
      }
    });
  }

  $rootScope.pageChangedObservers.push(checkForNewDispatch);

	$scope.closeDispatchAlert = function() {

		$scope.hideAlert = true;

    Users.acceptNewDispatch($rootScope.user).then(function(result) {

    });
	};

}]);

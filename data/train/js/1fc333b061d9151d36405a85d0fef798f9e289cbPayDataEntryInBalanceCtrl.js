/**
 * Created by caos on 7/15/2015.
 */

vantagePaydayAppApp.controller('PayDataEntryInBalanceCtrl', [
  '$scope',
  '$http',
  function($scope) {

    $scope.hoursEarningsShow = true;
    $scope.showHoursEarnings = function () {
      $scope.hoursEarningsShow = true;
      $scope.taxesShow = false;
      $scope.miscellaneousShow = false;
    };

    $scope.taxesShow = false;
    $scope.showTaxes = function(){
      $scope.hoursEarningsShow = false;
      $scope.taxesShow = true;
      $scope.miscellaneousShow = false;
    };

    $scope.miscellaneousShow = false;
    $scope.showMiscellaneous = function(){
      $scope.hoursEarningsShow = false;
      $scope.taxesShow = false;
      $scope.miscellaneousShow = true;

    }

  }
]);

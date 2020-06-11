'use strict';

angular.module('evenlyApp')
  .controller('WalletCtrl', ['$scope', function ($scope) {
    $scope.selectHistory = function() {
      console.log('show history');
      $scope.showHistory = true;
      $scope.showCards = false;
      $scope.showBankAccounts = false;
    };

    $scope.selectCards = function() {
      console.log('show cards');
      $scope.showHistory = false;
      $scope.showCards = true;
      $scope.showBankAccounts = false;
    };

    $scope.selectBankAccounts = function() {
      console.log('show bank accounts');
      $scope.showHistory = false;
      $scope.showCards = false;
      $scope.showBankAccounts = true;
    };

    $scope.showHistory = true;
  }]);

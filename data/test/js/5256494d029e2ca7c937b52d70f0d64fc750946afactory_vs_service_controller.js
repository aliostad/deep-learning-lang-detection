var app = angular.module('app');

app.controller('FactoryVsServiceController', ['$scope', 'MyServiceByService', 'MyServiceByFactory',
  function($scope, MyServiceByService, MyServiceByFactory) {
    $scope.messageByService = MyServiceByService.message;
    $scope.valueByService = MyServiceByService.value;
    $scope.funcByService = MyServiceByService.add;

    $scope.messageByFactory = MyServiceByFactory.message;
    $scope.valueByService = MyServiceByFactory.value;
    $scope.funcByService = MyServiceByFactory.add;
  }]);
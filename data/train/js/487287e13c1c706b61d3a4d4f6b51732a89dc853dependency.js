'use strict';
angular.module('demoApp').controller('Annotation-Dependency-Controller', [
  '$scope',
  'ServiceD',
  function ($scope, pippo) {
    $scope.hello = pippo.getHello();
    
    $scope.controller = ".controller('Annotation-Dependency-Controller', ['$scope','ServiceD', function ($scope, service) {}])";
    
  }
]).controller('Implicit-Dependency-Controller', function ($scope, ServiceD) {
  $scope.hello = ServiceD.getHello();
  $scope.controller = ".controller('Implicit-Dependency-Controller', function ($scope, ServiceD) {})";
});
//$injector annotation 
var injectorController = function ($scope, pippo) {
  $scope.hello = pippo.getHello();
  $scope.controller = "var injectorController = function ($scope, sercvice) {};injectorController.$inject = ['$scope','ServiceD'];angular.module('demoApp').controller('Injector-Dependency-Controller', injectorController);";
};
injectorController.$inject = [
  '$scope',
  'ServiceD'
];
angular.module('demoApp').controller('Injector-Dependency-Controller', injectorController);
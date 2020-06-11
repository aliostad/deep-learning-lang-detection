(function(){
  'use strict';

  angular.module('portfolio')
  .controller('HomeCtrl', ['$scope', function($scope){
    $scope.title = 'Joy Pratt';


    $scope.toggleProjects = function(){
      $scope.showProjects = true;
      $scope.showSkills = false;
      $scope.showResume = false;
    };

    $scope.toggleSkills = function(){
      $scope.showProjects = false;
      $scope.showSkills = true;
      $scope.showResume = false;
    };

    $scope.toggleResume = function(){
      $scope.showProjects = false;
      $scope.showSkills = false;
      $scope.showResume = true;
    };

    $scope.toggleHome = function(){
      $scope.showProjects = true;
      $scope.showSkills = true;
      $scope.showResume = true;
    };

    $scope.toggleHome();

  }]);
})();

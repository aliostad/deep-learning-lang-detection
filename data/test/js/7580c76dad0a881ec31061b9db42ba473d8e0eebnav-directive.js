(function () {
  'use strict';

  angular
    .module('step.nav')
    .directive('stepNav', stepNav);

  StepNav.$inject = ['$scope', 'step'];


  function stepNav() {
    var d;

    d = {
      restrict: 'E',
      scope: {
        active: '@',
        layout: '@'
      },
      controller: StepNav,
      transclude: true,
      replace: true,
      template:
        '<nav>' +
          '<div ng-if="stepNav.isActive()" class="{{stepNav.clazz()}}" ng-transclude></div>' +
        '</nav>'
    };

    return d;
  }

  function StepNav($scope, step) {
    var ctrl = this;

    ctrl.isActive = isActive;
    ctrl.isInline = isInline;

    $scope.stepNav = {
      isActive: isActive,
      clazz: clazz
    };


    function isActive() {
      var active;

      active = $scope.active;

      if (active !== false) {
        active = step.sequence() ? true : false;
      }

      return active;
    }

    function isInline() {
      return $scope.layout === 'inline';
    }

    function clazz() {
      return isInline() ? 'step-nav-inline' : 'step-nav-stack';
    }
  }
}());

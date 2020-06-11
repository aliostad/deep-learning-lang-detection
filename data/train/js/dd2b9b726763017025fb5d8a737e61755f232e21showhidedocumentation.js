'use strict';

/**
 * @ngdoc directive
 * @name grafterizerApp.directive:showHideDocumentation
 * @description
 * # showHideDocumentation
 */
angular.module('grafterizerApp')
  .directive('showHideDocumentation', function() {
    return {
      template: '<md-button aria-label="Show/hide documentation" ng-click="showUsage = !showUsage">' +
      '<span ng-hide="showUsage"> <i class="fa fa-angle-down"></i>' +
      ' Show documentation' +
      '</span>' +
      '<span ng-show="showUsage"> <i class="fa fa-angle-up"></i>' +
      ' Hide documentation' +
      '</span>' +
      '</md-button>',
      restrict: 'E',
      scope: {
        showUsage: '='
      }
    };
  });

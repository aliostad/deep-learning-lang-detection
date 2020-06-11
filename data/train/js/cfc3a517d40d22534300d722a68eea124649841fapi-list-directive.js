'use strict';

angular.module('apiListDirective', [])

.constant('apiListTemplatePath', document.baseURI + '/dist/templates/components/api-list/api-list.html')

/**
 * @ngdoc directive
 * @name apiList
 * @requires HackApi
 * @requires apiListTemplatePath
 * @description
 *
 * A footer list used for displaying a list of navigation links.
 */
.directive('apiList', function ($rootScope, HackApi, apiListTemplatePath) {
  return {
    restrict: 'E',
    scope: {
      category: '='
    },
    templateUrl: apiListTemplatePath,
    link: function (scope, element, attrs) {
      scope.apiListState = {};
      scope.apiListState.apiData = [];
      scope.apiListState.selectedItemId = null;

      HackApi.getAllApiData()
          .then(function (apiData) {
            scope.apiListState.apiData = apiData;

            if ($rootScope.selectedApi != null) {// TODO: refactor this for the new routing scheme
              scope.apiListState.selectedItemId = $rootScope.selectedApi.replace(/_/g, '.');
              console.log(scope.apiListState.selectedItemId);
            }
          });

      scope.$watch('category', function () {
        scope.apiListState.selectedItemId = null;
      });
    }
  };
});

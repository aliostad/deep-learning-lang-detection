'use strict';

angular.module('app.directives', [])
    .directive('searchbox', ['SearchService', function (SearchService) {
       return {
                restrict: "E",
                templateUrl: "partials/directives/searchbox.html",
                controller: function($scope){                
                    $scope.service = SearchService;                
                    $scope.submit = function(){                  
                      SearchService.search();
                    };
                }            
            };
    }])
    .directive('stats',[function() {
        return {
            restrict: "E",
            templateUrl: "partials/directives/stats.html",
            controller: ['$scope','SearchService',function ($scope,SearchService) {                
                $scope.SearchService = SearchService;
            }]
        };
    }])
    .directive('pages', [function () {
        return {
            restrict: "E",
            templateUrl: "partials/directives/pagination.html",
            controller: ['$scope', 'SearchService', function($scope, SearchService) {
                $scope.service = SearchService;
            }]
        };
    }])
    .directive('navbar', [function () {
        return {
            restrict: "E",
            templateUrl: "partials/directives/navbar.html",
            transclude: true
        };
    }])
    .directive('facets', [function () {
        return {
            restrict: "E",
            templateUrl: "partials/directives/facets.html",
            controller: ['$scope', 'SearchService', function($scope, SearchService) {
                $scope.SearchService = SearchService;
            }]
        };
    }])
    .directive('suggestions', ['SearchService', function (SearchService) {
        return {
            restrict: "E",
            templateUrl: "partials/directives/suggestions.html",
            controller: function($scope) {
                $scope.SearchService = SearchService;
                $scope.suggestions = SearchService.suggestions;
                $scope.searchSuggestion = function(item) {
                    SearchService.searchTerms = item;
                    SearchService.search();
                };
            }
        };
    }]);
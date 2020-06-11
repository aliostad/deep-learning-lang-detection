"use strict";

angular.module("algoland")
    .directive("alAlgo", function() {
        return {
            restrict: "E",
            replace: true,
            templateUrl: "partials/algo.html",
            scope: {
                showCategory: "=?",
                showPublished: "=?",
                algo: "="
            },
            link: function(scope){
                scope.showCategory = scope.showCategory !== undefined ? scope.showCategory : true;
                scope.showPublished = scope.showPublished !== undefined ? scope.showPublished : true;
            }
        };
    });


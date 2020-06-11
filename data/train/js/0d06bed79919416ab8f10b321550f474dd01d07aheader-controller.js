"use strict";

angular.module("issueTracker.controllers")
    .controller('HeaderController', ['$scope', '$rootScope','$location','authorizationService', 'identityService','notifyService', function ($scope, $rootScope, $location, authorizationService, identityService,notifyService) {
        $scope.identityService = identityService;
        $scope.$on("pageChanged", function (event, selectedPage) {
            $scope.currentPage = selectedPage;
        });

        $scope.logout = function(){
            authorizationService.logout();
            notifyService.showInfo('Logout successful!');
        }
    }]);
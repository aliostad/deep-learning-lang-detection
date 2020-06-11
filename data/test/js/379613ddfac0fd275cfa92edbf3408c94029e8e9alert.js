'use strict';
angular.module('RedhatAccess.header').controller('AlertController', [
    '$scope',
    'AlertService',
    'HeaderService',
    'securityService',
    function ($scope, AlertService, HeaderService, securityService) {
        $scope.AlertService = AlertService;
        $scope.HeaderService = HeaderService;
        $scope.securityService = securityService;
        $scope.closeable = true;
        $scope.closeAlert = function (index) {
            AlertService.alerts.splice(index, 1);
        };
        $scope.dismissAlerts = function () {
            AlertService.clearAlerts();
        };
    }
]);

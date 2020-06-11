/**
 * User: Daniel
 * 对应页面index.html
 */

(function() {
    var controller = angular.module('app.controller', ['gm.service', 'app.service']);

    controller.controller('AppCtrl', ['$scope', 'errorService', 'loadingService', function AppCtrl($scope, errorService, loadingService) {

        /*========== Widget Events ==================================================*/

        /*========== Scope Models ==================================================*/

        $scope.errorService = errorService;
        $scope.loadingService = loadingService;

        /*========== Scope Functions ==================================================*/

        /*========== Listeners ==================================================*/

        /*========== Watches ==================================================*/

        /*========== Private Functions ==================================================*/

    }]);

})();


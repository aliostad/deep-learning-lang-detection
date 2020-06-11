(function () {
    'use strict';

    angular.module('ClientApp')
        .directive('clientBlockerController', clientBlockerController);

    /**
     * This is the directive for the block controller.
     * Use:
     * <client-blocker-controller></client-blocker-controller>
     * to embed to controller in the html file.
     */

    function clientBlockerController(){
        return {
            restrict: 'E',
            scope: {},
            templateUrl: 'app/client/clientBlocker/client-blocker.html',
            controller: 'initBlockerController',
            controllerAs: 'blockerCtrl'
        };
    }

})();
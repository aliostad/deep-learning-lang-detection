(function () {
    'use strict';

    angular.module('ClientApp')
        .directive('clientLoginController', clientLoginController);

    /**
     * This is the directive for the login controller.
     * Use:
     * <client-login-controller></client-login-controller>
     * to embed to controller in the html file.
     */

    function clientLoginController(){
        return {
            restrict: 'E',
            scope: {},
            templateUrl: 'app/client/clientLogin/client-login.html',
            controller: 'initLoginController',
            controllerAs: 'loginCtrl'
        };
    }

})();
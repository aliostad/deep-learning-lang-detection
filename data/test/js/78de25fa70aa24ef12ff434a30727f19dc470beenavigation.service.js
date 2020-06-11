(function () {
    'use strict';

    function NavigationService(NOT_LOGGED, LOGGED, $state, authenticationService) {
        var that = this;

        that.getNavigation = getNavigation;

        function getNavigation() {
            return authenticationService.isUserAuthenticated() ? LOGGED : NOT_LOGGED;
        }
    }

    NavigationService.$inject = [
        'NOT_LOGGED',
        'LOGGED',
        '$state',
        'authenticationService'
    ];

    angular
        .module('app.component.navigation.service', [
            'app.component.navigation.constants',
            'app.authentication.service'
        ])
        .service('navigationService', NavigationService);
})();
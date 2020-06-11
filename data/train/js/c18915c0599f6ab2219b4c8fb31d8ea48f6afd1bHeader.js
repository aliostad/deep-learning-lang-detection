(function (angular) {
    'use strict';

    function HeaderService($rootScope) {
        var defaults,
            service;

        service = {};
        defaults = {
            title: "",
            showBackButton: false,
            backButtonTitle: "Back",
            backButtonCallback: function () {
                $rootScope.state.back();
            }
        };

        service.set = function (options) {
            service = angular.merge({}, defaults, options);
            $rootScope.$broadcast('header:updated', service);
        };

        return service;
    }

    HeaderService.$inject = [
        '$rootScope'
    ];

    angular.module('station')
        .service('HeaderService', HeaderService);

}(window.angular));

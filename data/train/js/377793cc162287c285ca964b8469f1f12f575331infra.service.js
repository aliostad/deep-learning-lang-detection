(function() {

    'use strict';

    angular
        .module('app.infra')
        .factory('infraService', InfraService);

    InfraService.$inject = ['$log', 'urlService'];

    function InfraService($log, urlService) {

        var service = {
            url: urlService,
        };

        return service;

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        // ---------- Public methods

        // ---------- Private methods

    }

})();
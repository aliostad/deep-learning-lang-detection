(function() {
    'use strict';

    angular
        .module('translateLocale')
        .service('homeService', homeService);

    homeService.$inject = ['commonDataService'];

    function homeService(commonDataService) {

        var service = {
            data: null,
            getMainAllData: getMainAllData
        };

        return service;

        function getMainAllData() {
            return commonDataService.getMainData().then(function(data) {
                service.data = data;
            });
        }
    }

})();

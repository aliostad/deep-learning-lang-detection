(function () {
    'use strict';

    angular
        .module('services.api')
        .service('RoService', RoService);

    RoService.$inject = ['apiService'];

    function RoService(apiService) {
        var service = {};

        service.createRoTemplate = function (params) {
            return apiService.post('Blogs/CreateTemplateApproval', params);
        }
        service.editRoTemplate = function (params) {
            return apiService.post('Blogs/CreateTemplateApproval', params);
        }

        service.deleteRoTemplate = function (params) {
            return apiService.post('Blogs/CreateTemplateApproval', params);
        }


        return service;
    }
})();
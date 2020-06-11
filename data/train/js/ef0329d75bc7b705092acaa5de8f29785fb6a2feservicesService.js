(function () {
    'use strict';

    angular
        .module('services.api')
        .service('servicesService', servicesService);

    servicesService.$inject = ['apiService'];

    function servicesService(apiService) {
        var service = {};

        // get Project Services By Project Id  
        service.getServicesByProjectId = function (projectId) {
            return apiService.getWithoutCaching('Services/GetServicesGrid/' + projectId);
        }

        // Get Services By Service Id 
        service.getServiceByServiceId = function (serviceId) {
            return apiService.getWithoutCaching('Services/GetEditMultiple/' + serviceId);
        }

        // Get Services By service Id To Edit
        service.getServiceByServiceIdToEditService = function (serviceId) {
            return apiService.getWithoutCaching('Services/GetEdit/' + serviceId);
        }

        // Edit Service By Service Id
        service.editService = function (params) {
            return apiService.post('Services/EditServiceSingle', params);
        }

        // create Service Tax Mapping
        service.createServiceTaxMapping = function (params) {
            return apiService.post('Services/CreateTaxMapping', params);
        }

        // Delete Multiple Services
        service.deleteMultipleServicesInProject = function (params) {
            return apiService.post('Services/DeleteMultipleServices', params);
        }


        return service;
    }

})();

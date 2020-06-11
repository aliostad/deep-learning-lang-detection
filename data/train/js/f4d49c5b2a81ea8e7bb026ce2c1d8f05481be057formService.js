(function () {
    'use strict';

    angular
        .module('services.api')
        .service('formService', formService);

    formService.$inject = ['apiService'];

    function formService(apiService) {
        var service = {};

        service.getFormId = function () {
            return apiService.get('Form/GenerateFormId');
        }

        service.getFormByOrgId = function (orgId) {
            return apiService.get('Form/GetForms/' + orgId);
        }

        service.saveFormToTeam = function (params) {
            return apiService.post('Form/FormToTeam', params);
        }

        return service;
    }
})();

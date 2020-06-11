(function(){
    'use strict';
    angular.module('template').factory('TemplateService', TemplateService);


    TemplateService.$inject = ['TemplateServiceRestangular', 'JobServiceRestangular', 'AuthorityRestangular', 'DeviceServiceRestangular'];
    function TemplateService(TemplateServiceRestangular, JobServiceRestangular, AuthorityRestangular, DeviceServiceRestangular) {
        var template;
        template = {
            template: TemplateServiceRestangular.all('api/bao-templates'),
            templateModule: JobServiceRestangular.all('api/bmcService/'),
            templateProcess: JobServiceRestangular.all('api/bmcService/queryProcessNames'),
            role: AuthorityRestangular.all('api/authorities'),
            upload: TemplateServiceRestangular.configuration.baseUrl + '/api/excelUpload',
            deGroup: DeviceServiceRestangular.all('api/device-groups')
        };
        return template;

    }
})();

'user strict'
define(['services/services', 'services/baseService']
    , function (services) {
        services.factory('diamondService', function (baseService) {
            var service = {};
            var api = 'Diamond';

            //查询获取diamondlist
            service.diamondsQuery = function (param) {
                return baseService.doPost(api, 'DiamondsQuery', param);
            };

            //批量调配钻石
            service.diamondsAssign = function (param) {
                return baseService.doPost(api, 'DiamondsAssign', param);
            };

            //service.reset = function (param) {
            //    param
            //};

            return service;

        });
    });
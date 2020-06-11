/**
 * Created by gapaa002 on 8/19/2014.
 */
(function () {
    'use strict';

    var serviceId = 'propertyService';

    angular.module('utility.property')
        .service(serviceId, propertyService);

    propertyService.$inject = ['$http', 'GROUNDTRANSFER_CONSTANT', 'serviceURLHostFactory', 'logger'];

    function propertyService($http, GROUNDTRANSFER_CONSTANT, serviceURLHostFactory, logger) {
        var PROPERTY_SERVICE_POST_URL = GROUNDTRANSFER_CONSTANT.PROPERTY_POST_URL;
        var PROPERTY_SERVICE_GETALL_URL = GROUNDTRANSFER_CONSTANT.PROPERTY_GETALL_URL;
        var PROPERTY_SERVICE_MODIFY_URL = GROUNDTRANSFER_CONSTANT.PROPERTY_MODIFY_URL;

        this.saveProperty = function (inputData) {
            return $http.post(serviceURLHostFactory.getServiceServerHost() + PROPERTY_SERVICE_POST_URL, inputData);
        };

        this.getAllProperty = function () {
            return $http.get(serviceURLHostFactory.getServiceServerHost() + PROPERTY_SERVICE_GETALL_URL);
        };
        this.modifyProperty = function (configId, inputData) {
            logger.log("--modify URL=" +
            serviceURLHostFactory.getServiceServerHost() + PROPERTY_SERVICE_MODIFY_URL + configId);
            return $http.put(serviceURLHostFactory.getServiceServerHost() +
            PROPERTY_SERVICE_MODIFY_URL + configId, inputData);
        };
    }
})();
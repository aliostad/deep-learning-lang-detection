'use strict';

var appServices = angular.module('appServices', []);


//appServices.factory('AcquisitionService', ['Restangular',
//    function (Restangular) {
//        return Restangular.service('acquisitions');
//    }]);


appServices.factory('BarcodeService', ['Restangular',
    function BarcodeService (Restangular) {
        return Restangular.service('barcodes');
    }]);


appServices.factory('ConfigService', ['Restangular',
    function ConfigService (Restangular) {
        return Restangular.service('config');
    }]);


//appServices.factory('CustomerService', ['Restangular',
//    function CustomerService (Restangular) {
//        return Restangular.service('customers');
//    }]);


appServices.factory('ErrorService', ['Restangular',
    function ErrorService (Restangular) {
        return Restangular.service('error');
    }]);


appServices.factory('ItemService', ['Restangular',
    function ItemService (Restangular) {
        return Restangular.service('items');
    }]);


appServices.factory('SessionService', ['Restangular',
    function SessionService (Restangular) {
        return Restangular.service('session');
    }]);


appServices.factory('StocktakingService', ['Restangular',
    function StocktakingService (Restangular) {
        return Restangular.service('stocktakings');
    }]);


appServices.factory('UnitService', ['Restangular',
    function UnitService (Restangular) {
        return Restangular.service('units');
    }]);


appServices.factory('VendorService', ['Restangular',
    function VendorService (Restangular) {
        return Restangular.service('vendors');
    }]);


//appServices.factory('WorkService', ['Restangular',
//    function WorkService (Restangular) {
//        return Restangular.service('works');
//    }]);

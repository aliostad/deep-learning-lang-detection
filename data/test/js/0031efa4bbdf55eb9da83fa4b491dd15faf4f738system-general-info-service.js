'use strict';

angular.module('imm3.system.general.info.service', ['ngResource'])

    .factory('systemGeneralInfoService', ['$resource', function($resource) {
        var service = {};

        service.restGeneralInfo = function() {
			// getting session info
			return $resource('/api/providers/sessioninfo');
        };

        return service;
    }])
    .factory('immPropertyService',['$resource',function($resource){
        var service = {};

        service.restSysTime = function() {
            return $resource('/api/dataset/imm_properties');
        }
        return service;
    }])
	.factory('immExportService',['$resource',function($resource){
        var service = {};

        service.restExport = function() {
            return $resource('/api/providers/imm_export');
        }
        return service;
    }])
    .factory('dataSetService',['$resource', function($resource){
        var service = {};
        service.restDataSet = function(){
            return $resource('/api/dataset');
        }
        return service;
    }])
;
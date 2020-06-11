angular.module('MxApplication.services')
	.factory('PublicApiService', ['$resource', function ($resource) {
	    var publicApi = $resource('/api/v1/PublicApi');
	    var keyApi = $resource('/api/v1/ApiKey', {}, {
	        'query': {
	            method: 'GET',
	            isArray: false
	        }
	    });

	    return {
	        getPublicApis: function () {
	            return publicApi.query();
	        },
	        getApiKey: function (gen) {
	            return keyApi.query({ generate: gen ? "1" : "0" });
	        },
	        revokeApiKey: function () {
	            return keyApi.delete();
	        }
	    };
	}]);

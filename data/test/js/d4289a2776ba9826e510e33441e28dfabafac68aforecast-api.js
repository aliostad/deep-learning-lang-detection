(function () {
    'use strict';

    angular
        .module('app')
        .factory('forecastApiService', forecastApiService);

	forecastApiService.$inject = ['$http', '$rootScope'];

    /* @ngInject */
    function forecastApiService($http, $rootScope) {
        //https://api.forecast.io/forecast/9fff32769f6e2210474fe419ceda1e78/37.8267,-122.423
        var apiUrl = "https://api.forecast.io/forecast/";
        var apiKey = "9fff32769f6e2210474fe419ceda1e78";

	    apiUrl += apiKey + '/';

        var api = {apiUrl : apiUrl};

        //-----------------------------------------------------------------------------
        //
        api.getForecast = function(latitude, longitude) {
            return $http.get(apiUrl + latitude + ',' + longitude);
        };

	    api.getHistory = function(latitude, longitude, time) {
		    return $http.get(apiUrl + latitude + ',' + longitude + ',' + time);
	    };

        return api;
    }

})();

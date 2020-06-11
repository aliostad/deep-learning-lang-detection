( function() {
	'use strict';

	function TVPopularService($http, $log){

		var service = {};

		service.TVPopular = [];

		service.getMovie = function () {

			var key = '894265c196e11346d6dcb219e2e9d884';

			return $http.get('https://api.themoviedb.org/3/tv', {
				params:{
					api_key: key
				}
			})
			.success(function (data) {
				service.TVPopular = data;
			})
			.error(function () {
				console.log('error');
			});
		};

		return service;

	}

	angular.module('service.TVPopular', [])
		.factory('TVPopularService', TVPopularService);

})();
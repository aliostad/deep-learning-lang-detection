( function() {
	'use strict';

	function MoviePlayingService($http, $log){

		var service = {};

		service.moviePlaying = [];

		service.getMovie = function () {

			var key = '894265c196e11346d6dcb219e2e9d884';

			return $http.get('https://api.themoviedb.org/3/movie/now-playing', {
				params:{
					api_key: key
				}
			})
			.success(function (data) {
				service.moviePlaying = data;
			})
			.error(function () {
				console.log('error');
			});
		};

		return service;

	}

	angular.module('service.moviePlaying', [])
		.factory('MoviePlayingService', MoviePlayingService);

})();
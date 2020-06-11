'use strict';

var PostService = angular.module('PostServiceTest', []);

 PostService.service('postService', [ '$http', function($http ) {
	var postService = this;
	
	postService.test ="this is postService";
	
	postService.post = function(data, url) {
		console.log(data)

		return	$http.post('http://chanmao.ca/?r=%20rrclient/' + url, data).
				success(function(response, status, headers, config) {
			      postService.response = response;
			       // console.log( postService.result)
			      // return postService.result;
			     
			    }).
			    error(function(response, status, headers, config) {
			      postService.response = 'Please Check Your Network!';
			      // return postService.result;
			      
			    });
			     // return postService.result;
		  	};
	postService.testF = function  () {
		return postService.test
	}
}]);
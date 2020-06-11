'use strict';
/**
 * UserAdminService
 */
angular.module('service.userAdmin', [])

.constant('SERVICE_CONFIG', {
	//URL : 'http://localhost:8080/conferenceroom-service'
    URL: 'http://cr-service.elasticbeanstalk.com'
})

.factory('UserAdminService', function($http, SERVICE_CONFIG) {

	var service = {};
	
	/**
	 * API Methods
	 */
	service.getUser = function(userId) {
		var userAdminServiceUrl = SERVICE_CONFIG.URL + "/service/user/" + userId;
		var getConfig = {
		};
		return $http.get(userAdminServiceUrl, getConfig).then(function(response) {
			return response.data;
		});
	}; 

	service.addUser = function(user) {
		var userAdminServiceUrl = SERVICE_CONFIG.URL + "/service/user/add";
		var postConfig = {};
		return $http.post(userAdminServiceUrl, user, postConfig).then(function(response) {
			return response;
		});
	};

	service.updateUser = function(user) {
		var userAdminServiceUrl = SERVICE_CONFIG.URL + "/service/user/update";
		var postConfig = {};
		return $http.post(userAdminServiceUrl, user, postConfig).then(function(response) {
			return response;
		});
	};

	service.deleteUser = function(userId) {
		var userAdminServiceUrl = SERVICE_CONFIG.URL + "/service/user/delete/" + userId;
		var deleteConfig = {
		};
		return $http.delete(userAdminServiceUrl, deleteConfig).then(function(response) {
			return response.data;
		});
	}; 

	service.findUser = function(matchText) {
		var userAdminServiceUrl = SERVICE_CONFIG.URL + "/service/user/find";
		var getConfig = {
				params: {
					'sq' : matchText
				}
		};
		return $http.get(userAdminServiceUrl, getConfig).then(function(response) {
			return response.data;
		});
	};
	
	service.listUsers = function() {
		var userAdminServiceUrl = SERVICE_CONFIG.URL + "/service/user/list";
		var getConfig = {
		};
		return $http.get(userAdminServiceUrl, getConfig).then(function(response) {
			return response.data;
		});
	};

	return service;		
});
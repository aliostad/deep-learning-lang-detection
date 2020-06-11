(function () {
	'use strict';
// Module constructor
	angular.module('ga.resources').factory('Repo', ['$resource', 'apiHost', function ($resource, api) {
		return $resource(api + '/api/1/repos', {}, {});
	}]);
	angular.module('ga.resources').factory('Commit', ['$resource', 'apiHost', function ($resource, api) {
		return $resource(api + '/api/1/repos/:repo/commits', {}, {});
	}]);

	// Services
	angular.module('ga.resources').factory('Reload', ['$resource', 'apiHost', function ($resource, api) {
		return $resource(api + '/api/1/reload', {}, {});
	}]);
}());
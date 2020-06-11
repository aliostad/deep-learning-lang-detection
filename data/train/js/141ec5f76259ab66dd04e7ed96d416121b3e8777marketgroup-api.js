angular.module('api.marketgroups', ['api.utilities']).

factory('marketGroupApi', ['apiUtilities', function(apiUtilities) {
	return {
		getMarketGroups: function(cb) {
			apiUtilities.callApi("/api/inv/marketgroups", cb);
		},
		getParentMarketGroups: function() {
			apiUtilities.callApi("http://localhost:8080/api/inv/marketgroups/parent/null", cb);
		},
		getTypesByMarketGroupID: function(mgID, cb) {
			apiUtilities.callApi("/api/inv/types/marketgroup/" + mgID, cb);
		},
		getMarketGroupByID: function(mgID, cb) {
			apiUtilities.callApi("http://localhost:8080/api/inv/marketgroups/" + mgID, cb);
		}
	};
}]);
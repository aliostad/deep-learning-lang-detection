//angular.module('localServiceProviderApp', [])
angular
    .module('localServiceProviderApp')
    // super simple service
    // each function returns a promise object 
    .factory('ServiceProviders', function($http) {
        return {
            get : function() {
                return $http.get('/api/service_providers');
            },
            getById : function(id) {
                return $http.get('/api/service_providers/' + id);
            },
            create : function(newServiceProvider) {
                return $http.post('/api/service_providers', newServiceProvider);
            },
            edit : function(serviceProvider) {
                return $http.put('/api/service_provider', serviceProvider);
            },
            delete : function(id) {
                return $http.delete('/api/service_providers/' + id);
            }
        }
    });
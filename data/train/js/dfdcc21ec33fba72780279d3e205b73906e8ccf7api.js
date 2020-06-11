angular.module('droppop.services')
    
    // .constant('API_URL', 'http://drop-pop-api.pagodabox.com/api/')
    .constant('API_URL', 'http://droppop.api/api/')
    
    .service('$api', function($http, API_URL) {
        
        return {
            
            get: function(url) {
                return $http.get(API_URL + url).then(function(response) {
                    return response.data.data;
                });
            },
            
            post: function(url, data) {
                return $http.post(API_URL + url, data).then(function(response) {
                    return response.data.data;
                });
            }
            
        };
    })

;
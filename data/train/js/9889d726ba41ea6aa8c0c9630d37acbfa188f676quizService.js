/**
 * Service to manage quiz
 */
angular.module('trainer').factory('quizService', ['$http', '$q',
    function($http, $q) {
    
    var service = {};
    
    service.words = [];
    
    service.index = -1;
    
    service.score = 0;
    
    service.finalScore = null;
    
    service.loadQuiz = function(lexiconId) {
        var deferred = $q.defer();
        $http.post("/quiz/generate", {lexiconId: lexiconId, number: 20, tags: []})
            .success(function(data) {
                service.words = data;
                service.index = 0;
                service.score = 0;
                deferred.resolve(data[0]); 
            })
            .error(function(error) {
                deferred.reject(error);
            });
        return deferred.promise;
    };
    
    service.nextWord = function() {
        service.index++;
        if(service.index >= service.words.length) {
            service.finalScore = service.score * (20 / service.words.length);
            return null;
        }
        return service.words[service.index];
    };
    
    service.checkWord = function(response) {
        var current = service.words[service.index];
        response = response.trim();
        for(var i = 0; i < current.translations.length; i++) {
            var responses = current.translations[i].term.split(',');
            for(var j = 0; j < responses.length; j++) {
                if(responses[j].trim() === response) {
                    service.score++;
                    return true;
                }
            }
        }
        
        return false;
    };
    
    return service;
}]);


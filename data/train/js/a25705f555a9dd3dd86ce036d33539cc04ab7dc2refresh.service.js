(function() {
    'use strict';

    angular
        .module('app.core')
        .factory('refreshService', refreshService);

    refreshService.$inject = ['songsService', 'profileService', 'libraryService', 'thumbsService'];

    function refreshService(songsService, profileService, libraryService, thumbsService) {
        
        var service = {
            resolve: resolve,
            resolveProfile: resolveProfile
        };

        return service;

        //// exported

        function resolve(uid) {
            return profileService.get(uid)
                .then(function() {
                    return libraryService.setReference();
                })
                .then(function() {
                    return songsService.set();
                })
                .then(function() {
                    return thumbsService.set();
                })
                .catch(function(error) {
                    console.error(error);
                });
        }

        function resolveProfile(uid) {
            return profileService.get(uid);
        }
    }
})();
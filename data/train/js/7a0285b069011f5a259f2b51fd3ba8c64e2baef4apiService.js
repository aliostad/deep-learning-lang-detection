'use strict';

angular.module('spotlight.services').service('apiService', [function () {

    /**
     * Loads the Spotify API and invokes a callback on the result.
     *
     * @param {Function} callback
     */
    this.api = function (callback) {
        var requireCallback = function (activity, audio, auth, devtools, facebook, i18n, library, location, models, offline, relations, runtime, search, toplists) {
            var api = {
                activity: activity,
                audio: audio,
                auth: auth,
                devtools: devtools,
                facebook: facebook,
                i18n: i18n,
                library: library,
                location: location,
                models: models,
                offline: offline,
                relations: relations,
                runtime: runtime,
                search: search,
                toplists: toplists
            };
            callback(api);
        };
        require([
            '$api/activity',
            '$api/audio',
            '$api/auth',
            '$api/devtools',
            '$api/facebook',
            '$api/i18n',
            '$api/library',
            '$api/location',
            '$api/models',
            '$api/offline',
            '$api/relations',
            '$api/runtime',
            '$api/search',
            '$api/toplists'
        ], requireCallback);
    };
}]);

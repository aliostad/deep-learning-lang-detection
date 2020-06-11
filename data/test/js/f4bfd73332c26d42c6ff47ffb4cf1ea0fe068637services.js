define(function (require) {
    require('angular');
    var module = angular.module('beerApp.services', []);

    module.service("BreweryService", require('service/brewerydb'));
    module.service('LocationService', require('service/location'));
    module.service('LocationParserService', require('service/location_search'));
    module.service('QaapiService', require('service/qaapi'));
    module.service('TweetService', require('service/twitter'));
    module.service('UserModelingService', require('service/usermodeling'));
});

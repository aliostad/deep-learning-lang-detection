var arabicSite = angular.module('arabicSite');

arabicSite.factory('alertService', function() {
    var service = {};

    // The message to be displayed
    service.message;

    // The alert type, e.g. noMatches, setComplete
    service.type

    service.visible = false;

    service.set = function(type, message) {
        service.message = message;
        service.type = type;
        service.visible = true;
    }

    service.clear = function() {
        service.message = null;
        service.alertType = null;
        service.visible = false;
    }

    return service;
})
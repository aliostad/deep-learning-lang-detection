angular.module('WLGame').factory('refreshers', function () {
    var service = {};

    console.log('service initialized');

    service.refreshers = {};

    service.add = function (id, callback, interval, executeImmediately) {
        service.remove(id);
        if (executeImmediately !== false) {
            callback();
        }
        service.refreshers[id] = setInterval(callback, interval);
    };
    service.remove = function (id) {
        if (service.refreshers.hasOwnProperty(id)) {
            clearInterval(service.refreshers[id]);
        }
    };
    service.clear = function () {
        for (var property in service.refreshers) {
            service.remove(property);
        }
    };

    return service;
});

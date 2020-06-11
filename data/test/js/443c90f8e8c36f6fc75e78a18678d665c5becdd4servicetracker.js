"use strict";
// External
var _ = require("underscore");

// inernal
var check = require("./exceptions").create("serviceTracker");

module.exports = function (service, binder) {
    check.notNull(service, "service");
    check.notNull(binder, "binder");

    var handler = function (otherService) {
        if (otherService !== service) {
            binder.bind(otherService);
        }
    };

    var stopHandler = function (otherService) {
        if (otherService !== service) {
            binder.unbind(otherService);
        }
    };

    var started = false;

    this.start = function (context) {
        if (!started) {
            started = true;
            _.each(service.consumes(), function (e) {
                context.findServices(e.serviceClass, handler);
            });

            context.on("serviceStarted", handler);
            context.on("serviceStopped", stopHandler);
        }
    };

    this.stop = function (context) {
        if (started) {
            context.removeListener("serviceStarted", handler);
            context.removeListener("serviceStopped", stopHandler);
        }
    };
};
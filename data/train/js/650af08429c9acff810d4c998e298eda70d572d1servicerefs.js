"use strict";
// External
var _ = require("underscore");

var check = new require("./exceptions").create("serviceRef");

module.exports.SimpleServiceRef = function (service, context) {
    check.notNull(service, "service");
    check.notNull(context, "context");

    var list = [];

    // Map: ServiceId --> instance.
    var instances = {};

    this.toString = function () {
        return list.join(",");
    };

    this.isRefBy = function (otherService) {
        return instances[otherService.getServiceId()] !== undefined;
    };
    
    // Get the actual service instance.
    // A caller must handover the other service uses the instance.
    // This will help to count the references.
    this.get = function (otherService) {
        check.notNull(otherService, "otherService");

        var serviceInstance = instances[otherService.getServiceId()];

        if (!serviceInstance) {
            var module = service.getModule();
            var instance = context.require(module);

            serviceInstance = instance;
            if (_.isFunction(instance)) {
                serviceInstance = new instance();
            }

            if (serviceInstance.activate) {
                serviceInstance.activate(context);
            }

            instances[otherService.getServiceId()] = serviceInstance;
        }

        list.push(otherService.getServiceId());

        return serviceInstance;
    };

    // Unget the service instance.
    // A caller must handover the service which releases the instance.
    // The caller is not allowd to use the instance afterwards.
    // The ref count will be decreased.
    this.unget = function (otherService) {
        check.notNull(otherService, "otherService");

        var i = _.indexOf(list, otherService.getServiceId());
        list.splice(i, 1);
        delete instances[otherService.getServiceId()];

        /*
         if(list.length === 0) {

         if(instance.deactivate) {
         instance.deactivate(context);
         }
         }
         */

    };
};
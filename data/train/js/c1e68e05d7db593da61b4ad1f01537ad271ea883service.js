define([], function () {
    Application.module("Entities", function (Entities, Application, Backbone, Marionette, $, _) {

        Entities.serviceUrl = "/service";

        Entities.Service = Entities.Model.extend({
            urlRoot: Entities.serviceUrl,
            validation: {
                name: {
                    required: true,
                    fn: 'doesNotExist'
                }

            },

            doesNotExist: function (value, attr, computedState) {
                if (_.contains(computedState.existingNames, value))
                    return "Service already exists";
            }
        });

        Entities.ServiceCollection = Entities.Collection.extend({
            url: Entities.serviceUrl,
            model: Entities.Service
        });

        var API = {
            getService: function (serviceId) {
                if (!serviceId)
                    return new Entities.Service();

                var service = new Entities.Service();
                service.id = serviceId;
                service.fetch();
                return service;
            },

            getServiceName: function (serviceId) {
                if (!serviceId) {
                    console.log("Need service id")
                    return "";
                }

                var service = this.getAllServices().get(serviceId);
                if (!service) {
                    console.log("Could not find service for id: " + serviceId)
                    return "";
                }
                return service.get('name');
            },

            getServiceNames: function (serviceIdArr) {
                if (!serviceIdArr || !(serviceIdArr instanceof Array)) {
                    console.log("Need service id array")
                    return "";
                }

                var that = this;
                var serviceNameArr = [];
                _.forEach(serviceIdArr, function(serviceId){
                    var service = that.getAllServices().get(serviceId);
                    if (!service) {
                        console.log("Could not find service for id: " + serviceId);
                    } else {
                        serviceNameArr.push(service.get('name'));
                    }
                });
                return serviceNameArr;
            },

            getAllServices: function () {
                if (!Entities.allServices) {
                    Entities.allServices = new Entities.ServiceCollection();
                    Entities.allServices.fetch();
                }
                return Entities.allServices;
            }
        };

        Application.reqres.setHandler(Application.GET_SERVICES, function (update) {
            return API.getAllServices(update);
        });

        Application.reqres.setHandler(Application.GET_SERVICE, function (serviceId) {
            return API.getService(serviceId);
        });

        Application.reqres.setHandler(Application.GET_SERVICE_NAME, function (serviceId) {
            return API.getServiceName(serviceId);
        });

        Application.reqres.setHandler(Application.GET_SERVICE_NAMES, function (serviceIdArr) {
            return API.getServiceNames(serviceIdArr);
        });
    })
});
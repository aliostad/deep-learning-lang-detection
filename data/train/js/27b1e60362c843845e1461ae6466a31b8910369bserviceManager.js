define(['jquery',
    'underscore',
    'backbone',
    'globalSettings',
    'bootbox',
    'toastr'
], function($, _, Backbone, GlobalSettings, bootbox, toastr) {

    var ServiceManager = function(serviceName, serviceType) {
        this.service = '';
        this.serviceName = '';
        this.serviceType = '';
        this.serviceRequest = '';

        this.setupService = function(name, type) {
            this.serviceName = name;
            this.serviceType = type;
            this.service = new ROSLIB.Service({
                ros: ros,
                name: this.serviceName,
                serviceType: this.serviceType
            });
        };

        this.setupRequest = function(serviceJSON) {
            this.serviceRequest = new ROSLIB.ServiceRequest(serviceJSON);
        };

        this.callService = function(callback) {
            var running = false;
            if (!running) {
                running = true;
                serviceName = this.serviceName;
                this.service.callService(this.serviceRequest, function(response) {
                    console.log(response);
                    if (response.hasOwnProperty('res')) {
                        if (response.res == true) {
                            toastr.success(serviceName, "Operation successful");
                        } else {
                            toastr.error(serviceName, "Operation failure");
                        }
                    }
                    if (callback) {
                        callback(response);
                    } else {
                        location.reload();
                    }
                })
            }
        };

        if (serviceName && serviceType &&
            serviceName != '' && serviceType != '') {
            this.setupService(serviceName, serviceType);
        }
    };
    return ServiceManager;
});
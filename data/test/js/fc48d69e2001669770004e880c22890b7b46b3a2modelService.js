define(['utils'], function (utils) {

    //service helpers

    var //parse options in services
        parseServices = function () {
            _.each(this._services, function (service) {
                service.id = service.id || _.uniqueId('service');
            });
        },

        //parse array initial services
        parseInitialServices = function () {
            this._initialServices = utils.parseArray(this._initialServices);
        },

        //service resolve callback
        onServiceResolve = function (service, data) {
            //store response data
            service.responseData = data;
            //check service options
            if (service.setModelAttr) {
                this.set(service.setModelAttr, data);
            }
            if (service.onSuccess) {
                utils.foo(this, service.onSuccess, undefined, data, service);
            }
            triggerServiceInProgress.call(this, service);
        },

        //service reject callback
        onServiceReject = function (service, responseError) {
            var serviceErrorCallback = service['onError' + responseError.code];
            service.responseData = undefined;
            if (serviceErrorCallback) {
                service[serviceErrorCallback]();
            }
            triggerServiceInProgress.call(this, service);
        },

        //trigger serviceInProgress:id and serviceInProgress with state
        triggerServiceInProgress = function (service) {
            var id = service.id,
                position = this._serviceInProgress.indexOf(id),
                nowInProgress = position < 0;
            //manage current services in progress
            if (nowInProgress) {
                this._serviceInProgress.push(id); //new service in progress
            } else {
                this._serviceInProgress[position] = undefined; //service in progress finish
                this._serviceInProgress = _.compact(this._serviceInProgress);
            }
            //trigger serviceInProgress:id state
            this.trigger('serviceInProgress:' + id, nowInProgress);
            //trigger serviceInProgress state
            if (nowInProgress && _.size(this._serviceInProgress) === 1) {
                this.trigger('serviceInProgress', true);
            } else if (_.size(this._serviceInProgress) === 0) {
                this.trigger('serviceInProgress', false);
            }
        },

        getServiceOptions = function () {
            return {
                app: this.app
            };
        };

    //extend model class

    _.extend(Backbone.Model.prototype, {

        //run initial services
        initServices: function () {
            parseServices.call(this);
            parseInitialServices.call(this);
            _.each(this._services, function (service) {
                if (this._initialServices.indexOf(service.id) >= 0) {
                    this.callService(service);
                }
            }, this);
        },

        //call ajax service
        callService: function (service) {
            var that = this;
            service.inProgress = true;
            triggerServiceInProgress.call(this, service);
            return utils.services.run(service, getServiceOptions.call(this))
                .done(function (responseData) {
                    onServiceResolve.call(that, service, responseData);
                })
                .fail(function (responseError) {
                    onServiceReject.call(that, service, responseError);
                })
                .always(function () {
                    service.inProgress = false;
                });
        },

        callServiceById: function (serviceId) {
            var service = _.find(this._services, function (_service) {
                return _service.id === serviceId;
            });
            return this.callService(service);
        },

        servicesInProgressCounter: function () {
            return _.size(this._serviceInProgress);
        },

        getServiceData: function (serviceId, attrs) {
            var service = _.find(this._services, function (service) {
                return service.id === serviceId;
            }) || {};
            return attrs ? utils.foo(service.responseData, attrs) : service.responseData;
        }

    });
});

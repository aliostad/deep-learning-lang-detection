'use strict';
var Promise = require('es6-promise').Promise;

module.exports = {
    name: 'Services',
    services: {},

    plugContext: function () {
      var services = this.services;

      return {
        plugActionContext: function(actionContext) {
          actionContext.getService = function(name) {
            var _service = {}

            for (var method in services[name]) {
              _service[method] = function() {
                var _arguments = arguments;

                return new Promise(function(resolve, reject) {
                  services[name][method].call({
                    resolve: resolve,
                    reject: reject
                  }, _arguments);
                });
              }
            }
            
            return _service;
          }
        }
      }
    },

    registerService: function registerService(service) {
      if (service && service.name) {
        service = this.services[service.name] = service;
        delete service.name;
      }
    },
}

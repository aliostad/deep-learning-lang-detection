var singletons = {};

function construct(service, args) {
  function Service() {
    return service.apply(this, args);
  }
  Service.prototype = service.prototype;
  return new Service();
}

module.exports.construct = construct;

module.exports.create = function (load) {
  return function (service) {
    if (singletons.hasOwnProperty(service.name)) {
      return singletons[service.name];
    } else {
      var serviceInstance = construct(service.constructor,
        service.dependencies.map(load));
      if (service.singleton) {
        singletons[service.name] = serviceInstance;
      }
      return serviceInstance;
    }
  }
};

module.exports.clean = function() {
  singletons = {};
};

module.exports.remove = function(name) {
  delete singletons[name];
};

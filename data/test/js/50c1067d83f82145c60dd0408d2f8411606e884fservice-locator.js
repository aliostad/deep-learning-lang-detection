function ServiceLocator() {
  this.reset();
}

ServiceLocator.prototype.get = function(name) {
  if (this.instances[name]) {
    return this.instances[name];
  }
  if (this.serviceRegistrars[name]) {
    return this.instances[name] = this.serviceRegistrars[name]();
  }
  throw new Error('Service `' + name + '` not found');
};

ServiceLocator.prototype.register = function(name, service) {
  if (service instanceof Function) {
    this.serviceRegistrars[name] = service;
  } else {
    this.instances[name] = service;
  }
};

ServiceLocator.prototype.unregister = function(name) {
  if (this.serviceRegistrars[name]) {
    delete this.serviceRegistrars[name];
  }
  if (this.instances[name]) {
    delete this.instances[name];
  }
};

ServiceLocator.prototype.reset = function() {
  this.serviceRegistrars = {};
  this.instances = {};
};

module.exports = new ServiceLocator();

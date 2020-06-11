udare.controller = (function(controllers, scope, injector, q, log, undefined) {
  log.info('udare.controller');
  
  var Controller = function(name, controller, module) {
    this.name = name;
    this.controller = controller;

    this.dependencies = injector.inject(controller, module);
  };
  Controller.prototype.init = function(scope) {
    this.scope  = scope;

    var dependencies = [];
    
    dependencies.unshift(scope);
    dependencies = dependencies.concat(this.dependencies);

    this.controller.apply(this.controller, dependencies);
  };

  return function(name, controller, module) {
    return controllers[name] = new Controller(name, controller, module);
  };
})(udare.controllers, udare.scope, udare.injector, udare.q, udare.log);
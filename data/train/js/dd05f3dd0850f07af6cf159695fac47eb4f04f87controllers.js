var ControllerNotFoundException = function(controllerName){
  var self = this;
  self.name = 'ControllerNotFoundException';
  self.message = 'Controller "'+controllerName+'" not registered';
}
ControllerNotFoundException.prototype = Object.create(Error.prototype);

var Controllers = function(){
  this._controllers = {};
};

Controllers.prototype.create = function(container, controllerName){
  var Controller = this._controllers[controllerName];
  if(!Controller){
    throw new ControllerNotFoundException(controllerName);
  }
  return new Controller(container);
};

Controllers.prototype.register = function(controllerName, controller){
  this._controllers[controllerName] = controller;
};
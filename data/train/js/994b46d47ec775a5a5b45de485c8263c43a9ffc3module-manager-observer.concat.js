/*! module-manager 2014-05-16 */
Module.FrontControllerModuleObserver = function FrontControllerModuleObserver(frontController) {
	this.frontController = frontController || null;
};

Module.FrontControllerModuleObserver.prototype = {

	frontController: null,

	constructor: Module.FrontControllerModuleObserver,

	_ensureControllerId: function(module) {
		module.controllerId = module.controllerId
		                   || module.options.controllerId
		                   || module.guid;
	},

	onModuleCreated: function(module, element, type) {
		this._ensureControllerId(module);
	},

	onSubModuleCreated: function(module, element, type) {
		this.frontController.registerController(module);
	},

	onModuleRegistered: function(module, type) {
		this.frontController.registerController(module);
	},

	onModuleUnregistered: function(module) {
		this.frontController.unregisterController(module);
	}

};
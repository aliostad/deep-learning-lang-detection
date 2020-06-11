var JAMTK = JAMTK || {};

JAMTK.ControllerManager = function() {
	this.controllers = {};
	this.defaultController;
	this.currentController;

	this.addController = function(id, controller, isDefault){
		this.controller[id] = controller;
		
		if(isDefault) {
			this.defaultController = controller;
		}
	}

	this.loadDefaultController = function(){

		if (this.defaultController) {
			this.loadControllerInstance(this.defaultController);
		} else {
			console.log("There is no default controller.");
		}
	}

	this.loadController = function(id){
		var controller = this.controllers[id];

		if (controller) {
			this.loadControllerInstance(controller);
		} else {
			console.log("There is no such controller : " + id);
		}

	}

	this.loadControllerInstance = function (instance) {
		if (this.currentController) {
			this.currentController.unload();
		}
		this.currentController = instance;
		this.currentController.load(this);
	}

}

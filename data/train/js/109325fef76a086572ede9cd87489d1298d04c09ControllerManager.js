define(["underscore"], function(_){ 

var ControllerManager = function(){
	this.collection = [];
	this.path = "controllers/";
}

ControllerManager.prototype._getControllerPath = function(name){
	return this.path + name;
}

ControllerManager.prototype._load = function(name, callback_fn){
	var __this = this;

	requirejs([ this._getControllerPath(name) ], function(Controller){
		__this._setController(name, Controller);
		callback_fn();
	});
}

ControllerManager.prototype._setController = function(name, Controller){
	this.collection.push({
		name: name, 
		controller: new Controller()
	});

	console.log('Instanciando controlador ' + name);
}

ControllerManager.prototype._findController = function(name){
	var row = _.findWhere(this.collection, {name: name});
	if(!_.isUndefined(row)){
		return row.controller;
	}

	return undefined;
}

ControllerManager.prototype._getController = function(name, defineController){
	var Controller = this._findController(name);
	var __this = this;

	if(_.isUndefined(Controller)){
		this._load(name, function(){
			//cuando se ha cargado la dependencia
			defineController(__this._findController(name));
		});
	}
	else{
		defineController(Controller);
	}
	
}

ControllerManager.prototype.executeController = function(controller_name, method_name){
	this._getController(controller_name, function(Controller){
		Controller[method_name]();
	});
}

return ControllerManager;
});
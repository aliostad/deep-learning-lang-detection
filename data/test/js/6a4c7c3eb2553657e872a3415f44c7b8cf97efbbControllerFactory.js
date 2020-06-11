'use strict';

var controllersPath = '../Controllers/';

var ControllerFactory = function (db, http, ws) {
    this._db = db;
    this._http = http;
    this._ws = ws;
}

ControllerFactory.prototype = {
    get: function (name) {
        if (name.indexOf('Controller') == -1) {
            name = name + 'Controller';
        }

        var Controller = this._getControllerType(name);
        var controller = new Controller();
        controller.init.call(controller, this._db, this._http, this._ws);
        return controller;
    },

    _getControllerType: function (name) {
        var controllerType = require(controllersPath + name);
        return controllerType;
    }
}

module.exports = ControllerFactory;
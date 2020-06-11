"use strict";

var ControllerFactory = {
    create: function(ControllerClass, view, arguments) {
        var container = Alloy.Globals.IOC.create();
        var Controller = function() {};
        Controller.destroy = function() {
            container.dispose();
        };
        ControllerClass.prototype = new Controller();
        ControllerClass.prototype.constructor = ControllerClass;
        container.register("Controller", ControllerClass);
        container.register("View", view);
        container.register("Arguments", arguments);
        return container.get("Controller");
    }
};

module.exports = ControllerFactory;
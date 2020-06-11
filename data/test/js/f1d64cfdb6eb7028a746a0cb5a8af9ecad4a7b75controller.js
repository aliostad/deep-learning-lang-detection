(function () {
    module("Viking.Controller");

    test("::extend acts like normal Backbone.Model", function() {
        var Controller = Viking.Controller.extend({key: 'value'}, {key: 'value'});
        
        equal(Controller.key, 'value');
        equal((new Controller()).key, 'value');
    });
    
    test("::extend with name", function() {
        var Controller = Viking.Controller.extend('controller');
        
        equal(Controller.controllerName, 'controller');
        equal((new Controller()).controllerName, 'controller');
    });
    
    test("action functions get a reference to the controller", function() {
        var Controller = Viking.Controller.extend('controller', {
            'index': function () {
                return true;
            }
        });
        
        var controller = new Controller();
        
        strictEqual(controller.index.controller, Controller);
    });
	
}());
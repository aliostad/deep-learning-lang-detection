define(['utils'], function (utils) {

    var parseController = function (id, options) {
            var controller = utils.config.get('controllers')[id];
            options = options || {};
            controller.id = id;
            controller.ev = options.ev || controller.ev || 'defaultEvent';
            controller.parentView = options.parentView || controller.parentView || this.appView;
            controller.regionName = options.regionName || controller.regionName || controller.parentView._defaultRegion;
            controller.region = controller.parentView[controller.regionName];
            controller.previousController = controller.region.getController();
            controller.options = _.extend({}, controller.options, options.options);
            return controller;
        },

        requireController = function (controller) {
            var that = this;
            require([controller.url], function (ctrl) {
                var instance = instanceController.call(that, ctrl, controller);
                controller.region.setController(instance);
                instance.evalEvent(controller.ev, controller.options);
            });
        },

        instanceController = function (ctrl, controller) {
            return utils.classes.instance('controller', ctrl, true, controller);
        };

    //extend application class

    _.extend(Marionette.Application.prototype, {

        loadController: function (id, options) {
            var controller = parseController.call(this, id, options),
                previousController = controller.previousController;
            if (previousController.id === controller.id) {
                previousController.evalEvent(controller.ev, controller.options);
            } else {
                utils.foo(previousController, 'willDestroy');
                requireController.call(this, controller);
            }
        }
    });
});
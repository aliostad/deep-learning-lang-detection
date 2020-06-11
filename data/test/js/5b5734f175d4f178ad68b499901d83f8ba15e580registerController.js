(function () {

    'use strict';

    /**
     * A utility function that registers each Controller into the Express framework.
     */
    var registerController = function (router, ControllerConstructor) {
        var controller = new ControllerConstructor();

        if (controller.list) {
            router.get(controller.URI, controller.read);
        }

        if (controller.read) {
            router.get(controller.URI, controller.read);
        }

        if (controller.create) {
            router.post(controller.URI, controller.create);
        }

        if (controller.update) {
            router.put(controller.URI, controller.update);
        }

        if (controller.remove) {
            router.delete(controller.URI, controller.remove);
        }
    };

    module.exports = registerController;

}());
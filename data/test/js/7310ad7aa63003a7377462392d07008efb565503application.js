define([
    'controller/mediator',
    'controller/mine-controller',
    'controller/physics-controller'
],
    function(Mediator, MineController, PhysicsController) {

        return {

            init: function() {
                this.startApp();
            },

            /**
             * Initialize the controllers that listens for events
             */
            startApp: function() {
                Mediator.init();
                MineController.init();
                PhysicsController.init();
            }

        };

    });
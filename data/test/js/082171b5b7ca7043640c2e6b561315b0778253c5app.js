define(['controller/dudeController'], function(dudeControllerInit) {

    var controller = function() {

            // Public functions
            return {
                init: function(elem) {
                    controller.elem = $(elem);
                    controller.dudeController = dudeControllerInit("#main");
                    return this;
                },
                run: function() {
                    controller.dudeController.render();
                }
            };
        };


    // init function
    return function(elem, options) {
        return Object.create(controller()).init(elem, options);
    };

});

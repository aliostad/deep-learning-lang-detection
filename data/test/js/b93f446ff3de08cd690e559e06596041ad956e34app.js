define(['controller/artistController'], function(artistControllerInit) {

    var controller = function() {

            // Public functions
            return {
                init: function(elem) {
                    controller.elem = $(elem);
                    controller.artistController = artistControllerInit("#artists");
                    return this;
                },
                run: function() {
                    controller.artistController.render();
                }
            };
        };


    // init function
    return function(elem, options) {
        return Object.create(controller()).init(elem, options);
    };

});

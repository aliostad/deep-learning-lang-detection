require(["bootstrap"], function() {
    $(document).ready(function(){
        var $body           = $(document.body),
            data_controller = $body.data('controller'),
            data_action     = $body.data('action');

        if(data_controller !== undefined && data_action !== undefined) {
            require(['controllers/' + data_controller], function(controller){
                if(controller) {
                    if(controller["init"] && typeof controller["init"] === "function") {
                        controller.init();
                    }

                    if(controller[data_action] && typeof controller[data_action] === "function") {
                        controller[data_action]();
                    }
                }
            });
        }
    });
});
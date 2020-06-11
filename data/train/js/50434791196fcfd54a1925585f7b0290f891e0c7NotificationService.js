app.service('NotificationService', function() {
    var subscribers = {};

    var service = {
        dispatch : function(msg, payload) {
            var dispatchTo = subscribers[msg];
            if (dispatchTo) {
                for (var i = 0; i < dispatchTo.length; i++) {
                    var fn = dispatchTo[i]
                    fn(payload);
                };
            }
        },

        subscribe : function(msg, fn) {
            subscribers[msg] = subscribers[msg] || [];
            subscribers[msg].push(fn);
        }
    }

    return service;

});

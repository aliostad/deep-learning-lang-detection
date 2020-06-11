(function ($) {
    $.extend({
        operator: function () {
            var _base = this;

            var createMessage = function (type, message) {
                return { type: type, message: message };
            };

            //messages
            _base.sendMessage = function (messageType, message) {
                var d = createMessage(messageType, message);
                _base.publish("send-message", d);
            };

            //info message
            _base.sendInfo = function (message) {
                _base.sendMessage("info", message);
            };

            //success message
            _base.sendSuccess = function (message) {
                _base.sendMessage("success", message);
            };

            //error message
            _base.sendError = function (message) {
                _base.sendMessage("error", message);
            };

            //generic pub/sub
            _base.publish = function (type, data) {
                pubsubz.publish(type, data);
            };

            _base.subscribe = function (type, callback) {
                pubsubz.subscribe(type, callback);
            };

            _base.unsubscribe = function(type) {
                pubsubz.unsubscribe(type);
            };

            return _base;
        }
    });
})(jQuery); 
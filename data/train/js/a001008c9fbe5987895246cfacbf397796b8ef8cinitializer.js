define([
    'jquery',
    'backbone',
    './models/message.model',
    './views/message.view'
], function($, Backbone, Message, MessageView){
    function showMessage(message, type, $el) {
        var view = new MessageView({
            model: new Message({
                type: type,
                text: message
            })
        });
        view.on('render', function() {
            $el.prepend(this.$el);
        });
        view.render();
        $el.foundation();
    }
    return function(options) {
        var $el = $(options.messagesContainer);
        this.commands.setHandler('message', function(message) {
            showMessage(message, Message.TYPE_NOTICE, $el);
        });
        this.commands.setHandler('message:error', function(message) {
            showMessage(message, Message.TYPE_ERROR, $el);
        });
        this.commands.setHandler('message:succeed', function(message) {
            showMessage(message, Message.TYPE_SUCCEED, $el);
        });
    };
});
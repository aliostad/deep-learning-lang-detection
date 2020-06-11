(function() {
    'use strict';

    function MessagesFeedService(chatSocketService, eventManagerService) {
        if (!chatSocketService.isOpenConnection()) {
            chatSocketService.connection();
        }

        this.em = eventManagerService.create();

        var addMessage = function(e) {
            this.em.trigger('updateMessages', e.params);
        }.bind(this);

        chatSocketService.on('message', addMessage);
        chatSocketService.on('sendMessage', addMessage);
    }

    angular.module('chat.feed')
        .service('messagesFeedService', ['chatSocketService', 'eventManagerService', MessagesFeedService]);
})();

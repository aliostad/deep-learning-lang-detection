(function() {

    'use strict';

    angular
        .module(APP_NAME)
        .controller('MessagesController', MessagesController);

    MessagesController
        .$inject = [
                    '$interval',
                    '$alert',
                    'Message',
                    'MessageService'
                   ];

    function MessagesController($interval, $alert, Message, MessageService) {
        var vm              = this;
        vm.receiveMessage   = receiveMessage;
        vm.message          = new Message();

        function receiveMessage(message) {
            vm.message  = message;
            vm.alert    = $alert({
                                    container: "#messageContainer",
                                    duration: 5,
                                    title: vm.message.title,
                                    content: vm.message.content,
                                    placement: 'top',
                                    type: vm.message.type,
                                    show: true
                                });
        }

        MessageService.addObserver(vm.receiveMessage);
    }

})();

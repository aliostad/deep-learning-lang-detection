'use strict';

describe('unit: MessageService', function() {

    var $MessageService;
    beforeEach(inject(function(MessageService) {
        $MessageService = MessageService;
    }));

    it("Should send and get a message", function() {
        var common = {
            callback: function(message) {
                $MessageService.getMessage();
            }
        };
        $MessageService.addObserver(common.callback);
        spyOn(common, "callback");
        //$MessageService.sendMessage("Message Title", "Message content", "success");
        $MessageService.sendMessage('subject.created.success');
    });

});

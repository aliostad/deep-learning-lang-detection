"use strict";

describe("Message", function() {
    var Message;

    beforeEach(module("bibframeEditor"));
    beforeEach(inject(function($injector) {
        Message = $injector.get("Message");
    }));

    it("should start with no messages", function() {
        expect(Message.messages().length).toEqual(0);
    });

    it("should add one message", function() {
        Message.addMessage("test", "critical");
        expect(Message.messages().length).toEqual(1);
        expect(Message.messages()[0].message.$$unwrapTrustedValue()).toEqual("test");
    });

    it("should end up with one message", function() {
        Message.addMessage("test0", "warning");
        Message.addMessage("test1", "info");
        Message.removeMessage(0);
        expect(Message.messages().length).toEqual(1);
        expect(Message.messages()[0].message.$$unwrapTrustedValue()).toEqual("test1");
    });
});

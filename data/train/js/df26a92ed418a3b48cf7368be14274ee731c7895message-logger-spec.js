var messageLogging = require("../../../lib/extensions/message-logger");
var messageHelper = require("../../helpers/message-helper.js");

var messageWithText = messageHelper.messageWithText;
var customMessageMatchers = messageHelper.custom_matchers;

describe("The message logger wraps data storage and provides and extension", function() {
    var handler, dataStore;

    beforeEach(function() {
        jasmine.addMatchers(customMessageMatchers);
        dataStore = {
            storeMessage: function (room, message){}
        };
        handler = messageLogging(dataStore).incoming;
        spyOn(dataStore, 'storeMessage');
    });


    it("leaves messages unchanged", function() {
        var message = messageWithText("I'm a little message and I'm okay");
        var expectedMessage = messageWithText("I'm a little message and I'm okay");
        handler(message, function(updatedMessage) {
            expect(updatedMessage).toMatchMessage(expectedMessage);
        });
    });

    it("passes the room and message to the storage", function() {
        var messageText = "I'm a little message and I'm okay";
        var message = messageWithText(messageText);
        handler(message, function(updatedMessage) {
            expect(dataStore.storeMessage.calls.argsFor(0))
                .toEqual(["logging-test", message]);
        });
    });


});
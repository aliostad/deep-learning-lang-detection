function getShortMessages(messageObjectsArray) {
    var messages = messageObjectsArray.map(function getMessageProperty(messageObject) {
    	return messageObject.message;

    }); // array of messages

    return messages.filter(function filterShortMessages(message) {
    	return message.length < 50;
    });
}

/* Option 2 chaining methods */
// function getShortMessages(messageObjectsArray) {
// 	return messageObjectsArray.filter(function (messageObject) {
// 		return messageObject.message.length < 50;
// 	}).map(function (message) {
// 		return message.message;
// 	});
// }


module.exports = getShortMessages;
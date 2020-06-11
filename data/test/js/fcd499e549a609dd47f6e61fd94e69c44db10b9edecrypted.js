'use strict';

module.exports = function(communicator, discussions) {
    return function(obj) {
	addMessage(communicator, discussions, obj);
    };
};

function addMessage(communicator, discussions, message) {
    if (!discussions[message.sender]) {
	discussions[message.sender] = [];
    }
    communicator.send({
    	action: 'decrypted',
	message: message.text,
	sender: message.sender,
	type: 'sender'
    });
    discussions[message.sender].push({
	type: 'sender',
	message: message.text,
	sender: message.sender
    });
}

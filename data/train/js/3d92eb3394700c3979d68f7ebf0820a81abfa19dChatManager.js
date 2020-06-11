(function() {
	'use strict';

	var snooze = require('snooze');

	snooze.module('chatApp')
		.service('ChatManager', function(UserManager, Message) {
			var messages = [];

			function createSystemMessage(message) {
				var M = Message.createMessage();
				M.name = 'System';
				M.message = message;

				return M;
			};

			function addMessage(socket, message) {
				console.log('message added');

				var M = Message.createMessage();
				M.name = UserManager.getUserDetails(socket).name;
				M.message = message;

				messages.push(M);

				return M;
			}

			function getAllMessages() {
				return messages;
			}

			return {
				addMessage: addMessage,
				createSystemMessage: createSystemMessage,
				getAllMessages: getAllMessages
			};
		});
})();
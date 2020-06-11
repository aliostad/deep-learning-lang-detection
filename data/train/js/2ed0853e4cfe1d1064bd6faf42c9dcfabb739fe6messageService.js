/* ѣ */
(function() {
	
	'use strict';
	
	var messageServiceFactory = function($timeout) {
		var MessageService = {
			promise: null,
			message: {
				type: '',
				text: ""
			},
			setMessage: function(message) {
				MessageService.message.text = message;
				MessageService.promise = $timeout(function() {
					MessageService.message.type = '';
					MessageService.message.text = "";
				}, 2000);
			},
			setError: function(message) {
				MessageService.message.type = 'error';
				MessageService.setMessage(message);
			},
			setInfo: function(message) {
				MessageService.message.type = 'info';
				MessageService.setMessage(message);
			},
			setDone: function(message) {
				MessageService.message.type = 'done';
				MessageService.setMessage(message);
			},
			clear: function() {
				MessageService.message.type = '';
				MessageService.message.text = "";
				$timeout.cancel(MessageService.promise);
			}
		};
		return MessageService;
	};
	
	
	angular.module('racepoint')
	.factory('messageService', messageServiceFactory);
	
})();

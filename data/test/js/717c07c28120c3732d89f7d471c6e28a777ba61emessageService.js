'use strict';

/**
 * Controller of the viewsApp
 */
angular.module('snapApp')
	.service('messageService', ['messageFactory', '$q', function (messageFactory, $q) {
		var defer = $q.defer();

		return {
			getMessages: function() {
				messageFactory.query(function(messages) {
					defer.resolve(messages);
				});
				return defer.promise;
			},
			saveMessage: function(userMessage, timer) {
				messageFactory.save({message: userMessage, timer: timer}, function(message) {
					defer.resolve(message);
				});
				return defer.promise;
			},
			deleteMessage: function(messageID, timer) {
				messageFactory.delete({message_id: messageID}, function(message) {
					defer.resolve(message);
				});
				return defer.promise;
			}
		}
	}]);

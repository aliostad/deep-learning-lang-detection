angular.module('scoreApp').service('alert', ['$rootScope', '$timeout', function($rootScope, $timeout) {
	var createMessage = function(type, text, timeout) {
		$rootScope.message = {
			type: type,
			text: text,
			show: true
		};

		$timeout(function() {
			$rootScope.message.show = false;
		}, timeout || 5000);
	};

	return {
		success: function(message, timeout) {
			createMessage('alert-success', message, timeout);
		},
		info: function(message, timeout) {
			createMessage('alert-info', message, timeout);
		},
		warning: function(message, timeout) {
			createMessage('alert-info', message, timeout);
		},
		danger: function(message, timeout) {
			createMessage('alert-danger', message, timeout);
		}
	};
}]);
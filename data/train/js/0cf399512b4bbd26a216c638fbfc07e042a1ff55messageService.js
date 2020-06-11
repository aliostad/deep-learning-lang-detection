hoard.service('messageService', function() {
	var messages = {
		errorMessage: null,
		warningMessage: null,
		successMessage: null,
		infoMessage: null
		};
	
	return {
		getMessages: function() {
			return messages;
		},
		setError: function(message) {
			messages.errorMessage = message;
		},
		setWarning: function(message) {
			messages.warningMessage = message;
		},
		setSuccess: function(message) {
			messages.successMessage = message;
		},
		setInfo: function(message) {
			messages.infoMessage = message;
		},
		clearAll: function() {
			messages.errorMessage = null;
			messages.warningMessage = null;
			messages.successMessage = null;
			messages.infoMessage = null;
		}
	}
});
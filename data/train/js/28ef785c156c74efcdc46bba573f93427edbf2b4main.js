var App = Backbone.Model.extend({
	selectors: {
		flashMessage: '#flash-messages'
	},
	isDebug: true,

	message: function(message, messageType) {
		var flashMessage = $('<div class="alert alert-' + messageType + ' fade in"><button type="button" class="close" data-dismiss="alert">&times;</button>' + message + '</div>');
		$(this.selectors.flashMessage).append(flashMessage);

		flashMessage.delay(6000).fadeOut();
	},

	error: function(message) {
		this.message(message, 'error');
	},

	warning: function(message) {
		this.message(message, 'warning');
	},

	success: function(message) {
		this.message(message, 'success');
	},

	info: function(message) {
		this.message(message, 'info');
	},

	debug: function(message) {
		if (this.isDebug === true) {
			var now = new Date();
			console.log('<' + now.getTime() + '> ' + message);
		}
	}
});

var app = new App();
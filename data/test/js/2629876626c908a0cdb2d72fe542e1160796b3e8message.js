messages = messages || {};

Template.flashMessage.rendered = function() {
	var message = Session.get('message');

	if(message) {
		new Message(message.type, message.message);
		Session.set('message', null);
	}
};

Template.flashMessageItem.events({
	'click .flash-message__action-ok' : function(e, tpl) {
		messages.activeMessage.callback();
		Session.set('message', null);
		Blaze.remove(tpl.view);
	},

	'click .flash-message__action-close': function(e, tpl) {
		Session.set('message', null);
		Blaze.remove(tpl.view);
	},
	'click .flash-message__action-cancel': function(e, tpl) {
		Session.set('message', null);
		Blaze.remove(tpl.view);
	}
});

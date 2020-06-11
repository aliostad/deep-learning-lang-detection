"use strict";
Chat.module("Message", function (Message, Chat, Backbone, Marionette) {
	Message.Controller = Marionette.Controller.extend({
		initialize: function () {
			this.messageCollection = new Message.MessageCollection();
			this.messageCollectionView = new Message.MessageCollectionView({
				collection: this.messageCollection
			});
			this.addMessageView = new Message.AddMessageView();
			this.addMessageView.on("addMessage", this.addMessage, this);
		},
		addMessage: function (message) {
			message.set("username", Chat.request("getUser").get("name"));
			this.messageCollection.add(message);
		}
	});
	Message.addInitializer(function () {
		new Message.Controller();
	});
});
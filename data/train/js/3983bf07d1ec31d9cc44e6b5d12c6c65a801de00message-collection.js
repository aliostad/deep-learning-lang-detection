define([
  'backbone',
  'models/message-model',
  'socket'
], function(Backbone, MessageModel, socket) {
  'use strict';

  var MessageCollection = Backbone.Collection.extend({
    model: MessageModel,
    initialize: function() {
      var messages = this;
      this.listenTo(socket, 'message', function(message) {
        // console.debug('receiving message:', message);
        messages.addMessage(message);
      });
    },

    addMessage: function(message) {
      this.add({content: message});
    }
  });
 
  return MessageCollection;
});
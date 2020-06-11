(function ($) {
  app.views.MessageEdit = Ractive.extend({
    template: '#message-edit-tmp',

    adaptors: ['Backbone'],

    init: function () {
      var self = this;

      this.hangHandlers();
      this.setNewMessage();
    },

    hangHandlers: function () {
      _.bindAll(this, 'postMessage', 'setMessage');

      this.on('postMessage', this.postMessage);
      app.globalMediator.on('editComment', this.setMessage);
    },

    setMessage: function (message) {
      this.set('message', message);
    },

    setNewMessage: function () {
      this.set('message', new app.models.MessageEdit());
    },

    postMessage: function () {
      var message = this.get('message');
      var messageText = message.get('text');

      if(message.isBelongToComment()) {
        message.postComment();
      } else {
        app.globalMediator.trigger('addNewMessage', messageText);
      }
      
      this.setNewMessage();
    },

    data: {
      message: null
    } 
  });
})(jQuery);
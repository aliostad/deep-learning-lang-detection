var Message = function() {};

_.extend(Message.prototype, {
  error: function(message, cls) {
    return this.message({type: 'error', message: message, cls: cls});
  },

  success: function(message, cls) {
    return this.message({type: 'success', message: message, cls: cls});
  },
  
  warn: function(message, cls) {
    return this.message({type: 'warn', message: message, cls: cls});
  },
  
  info: function(message, cls) {
    return this.message({type: 'info', message: message, cls: cls});
  },

  message: function(config) {
    config = _.extend({
      cls: '',
      type: 'success',
      message: 'Default message'
    }, config);

    return JST.message(config);
  }
});

module.exports = new Message();
function feedback(req, res, next){
  if (!res.locals || res.message) {
    return next();
  }

  var list = res.locals.messages = res.locals.messages || []

  function addMessage(type, message) {
    list.push({
      type: type, text: message
    });
  };

  ['error', 'warning', 'info', 'success'].forEach(function(level){
    addMessage[level] = function(message){
      res.message(level, message);
    }
  });

  addMessage.err  = addMessage.error;
  addMessage.warn = addMessage.warning;
  addMessage.win  = addMessage.success;

  res.message = addMessage;

  next();
}

module.exports = feedback;

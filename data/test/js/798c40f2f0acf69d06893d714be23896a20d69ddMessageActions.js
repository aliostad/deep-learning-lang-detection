/**
* @exports MessageAction
**/

var AppDispatcher = require('../dispatcher/AppDispatcher');
var MessageConstants = require('../constants/MessageConstants');

var MessageActions = {

  /**
   * @param  {object} message
   */
  createMessage: function(message) {
    AppDispatcher.dispatch({
      actionType: MessageConstants.MESSAGE_CREATE,
      message: message
    });
  },

  receiveCreatedMessage: function(message) {
    AppDispatcher.dispatch({
      actionType: MessageConstants.MESSAGE_RECEIVE_CREATED,
      message: message
    });
  },

  findOrCreateMessageThread: function(threadName) {

    AppDispatcher.dispatch({
      actionType: MessageConstants.THREAD_FIND_OR_CREATE,
      name: threadName
    });
  },

};

module.exports = MessageActions;

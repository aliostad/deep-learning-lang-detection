import Dispatcher from '../dispatcher/Dispatcher';
import Constants from '../constants/Constants';

const Actions = Constants.actions;

const ChatActions = {
  sendMessage: (message) => {
    Dispatcher.dispatch({
      actionType: Actions.SENDMESSAGE,
      message,
    });
  },
  setName: (name) => {
    Dispatcher.dispatch({
      actionType: Actions.SETNAME,
      name,
    });
  },
  receivedMessage: () => {
    Dispatcher.dispatch({
      actionType: Actions.MESSAGERECEIVED,
    });
  },
  fetchName: () => {
    Dispatcher.dispatch({
      actionType: Actions.FETCHNAME,
    });
  },
  hasMessages: () => {
    Dispatcher.dispatch({
      actionType: Actions.HASMESSAGES,
    });
  },
  fetchProperties: () => {
    Dispatcher.dispatch({
      actionType: Actions.FETCHPROPERTIES,
    });
  },
  signOut: () => {
    Dispatcher.dispatch({
      actionType: Actions.SIGNOUT,
    });
  },
};

module.exports = ChatActions;

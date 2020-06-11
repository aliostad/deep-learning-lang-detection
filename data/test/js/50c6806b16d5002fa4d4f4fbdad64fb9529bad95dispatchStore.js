var _ = require('lodash');
var Marty = require('marty');
var ActionStore = require('./actionStore');
var PageConstants = require('../constants/pageConstants');
var ActionConstants = require('../constants/actionConstants');
var DispatchConstants = require('../constants/dispatchConstants');

var DispatchStore = Marty.createStore({
  id: 'DispatchStore',
  handlers: {
    pageLoaded: PageConstants.PAGE_LOADED,
    revertToAction: ActionConstants.REVERT_TO_ACTION,
    recieveDispatch: DispatchConstants.RECEIVE_DISPATCH
  },
  getInitialState() {
    return { };
  },
  recieveDispatch(dispatch) {
    this.state[dispatch.id] = dispatch;
  },
  getDispatchForAction(actionId) {
    return _.find(this.state, (dispatch) => dispatch.action.id === actionId);
  },
  revertToAction(actionId) {
    var action = ActionStore.getActionById(actionId);

    _.each(this.state, (dispatch, dispatchId) => {
      if (dispatch.action.timestamp > action.timestamp) {
        delete this.state[dispatchId];
      }
    });
  },
  pageLoaded(sow) {
    _.each(sow.dispatches, dispatch => this.state[dispatch.id] = dispatch);
  }
});

module.exports = DispatchStore;
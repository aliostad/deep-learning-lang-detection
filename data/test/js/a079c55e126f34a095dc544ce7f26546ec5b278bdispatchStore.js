var _ = require('lodash');
var util = require('util');
var Marty = require('marty');

var PageConstants = require('../constants/pageConstants');
var ActionConstants = require('../constants/actionConstants');
var DispatchConstants = require('../constants/dispatchConstants');

var DispatchStore = Marty.createStore({
  id: 'DispatchStore',
  handlers: {
    addDispatch: DispatchConstants.RECEIVE_DISPATCH,
    revertToAction: ActionConstants.REVERT_TO_ACTION,
    clearDispatchesForTab: [
      PageConstants.PAGE_LOADED,
      PageConstants.PAGE_UNLOADED
    ],
  },
  getInitialState() {
    return {};
  },
  revertToAction(actionId) {
    var dispatch = this.getDispatchForAction(actionId);

    if (dispatch) {
      var action = dispatch.action;
      _.each(this.state, (dispatch, dispatchId) => {
        if (dispatch.action.timestamp > action.timestamp) {
          delete this.state[dispatchId];
        }
      });
    }
  },
  getDispatchForAction(actionId) {
    return _.find(this.state, dispatch => dispatch.action.id === actionId);
  },
  getDispatchesForTab(tabId) {
    return _.where(_.values(this.state), {
      tabId: tabId
    });
  },
  getDispatchById(dispatchId) {
    return this.state[dispatchId];
  },
  clearDispatchesForTab(tabId) {
    _.each(this.state, function (dispatch, id) {
      if (dispatch.tabId === tabId) {
        delete this.state[id];
      }
    }, this);

    this.hasChanged();
  },
  addDispatch(tabId, dispatch) {
    dispatch.tabId = tabId;
    this.state[dispatch.id] = dispatch;
    this.hasChanged();
  }
});

module.exports = DispatchStore;
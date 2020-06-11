var _ = require('lodash');
var Marty = require('marty');
var DispatchStore = require('./dispatchStore');
var PageConstants = require('../constants/pageConstants');
var ActionConstants = require('../constants/actionConstants');
var DispatchConstants = require('../constants/dispatchConstants');

var StoreStore = Marty.createStore({
  id: 'Stores',
  handlers: {
    pageLoaded: PageConstants.PAGE_LOADED,
    clearStores: PageConstants.PAGE_UNLOADED,
    revertToAction: ActionConstants.REVERT_TO_ACTION,
    updateStores: DispatchConstants.RECEIVE_DISPATCH,
  },
  getInitialState() {
    return {};
  },
  updateStores(dispatch) {
    if (dispatch) {
      _.each(dispatch.stores, function (store, storeId) {
        this.state[storeId] = store.state;
      }, this);

      this.hasChanged();
    }
  },
  clearStores() {
    this.clear();
    this.hasChanged();
  },
  revertToAction(actionId) {
    var dispatch = DispatchStore.getDispatchForAction(actionId);

    if (dispatch) {
      this.updateStores(dispatch);
    }
  },
  pageLoaded(sow) {
    this.clearStores();
    this.updateStores(latestDispatch());

    function latestDispatch() {
      return _.last(_.sortBy(sow.dispatches, function (dispatch) {
        return dispatch.action.timestamp;
      }));
    }
  },
  getStoreStates() {
    return this.state;
  }
});

module.exports = StoreStore;
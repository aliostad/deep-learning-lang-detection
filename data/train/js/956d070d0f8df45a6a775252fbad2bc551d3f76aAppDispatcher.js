'use strict';

var Dispatcher = require('flux').Dispatcher;
var AppDispatcher = Object.assign(new Dispatcher(), {

  dispatchViewAction: function(action) {
    this.dispatch({
      source: 'VIEW_ACTION',
      payload: action
    });
  },

  dispatchServerAction: function(action) {
    this.dispatch({
      source: 'VIEW_ACTION',
      payload: action
    });
  },

  dispatchAppAction: function(action) {
    this.dispatch({
      source: 'APP_ACTION',
      payload: action
    });
  }

});

module.exports = AppDispatcher;

/**
* @name dispatch
* @namespace
*/
(function(dispatch){

  /** Creates an element to bind global events to */
  dispatch.global = document.createElement('dispatch');

  /** Creates an object to store event data in */
  dispatch.events = {};

  /**
  * Creates new global event binding
  *
  * @public
  * @name dispatch#on
  * @function
  * @param {string} Event Name
  * @param {function} Method
  */
  dispatch.on = function(event, fn){
    // Creates object to store event data in
    var e = {
      ev: document.createEvent('Event'),
      fnc: fn,
      data: null
    };

    // Initialize event w/ name
    //(mocha-phantomjs doesn't support Event constructor)
    e.ev.initEvent(event,true, true);

    // Update method for data
    e.fnc = function(){
      return(fn.call(e.ev, e.data));
    };

    // Adds event object to global event array
    dispatch.events[event] = e;

    // Identifies correct binding method and applies event
    if (dispatch.global.addEventListener) {
        dispatch.global.addEventListener(event, e.fnc, false);
    } else {
        dispatch.global.attachEvent(event, e.fnc);
    }
  };

  /**
  * Removes global event binding
  *
  * @public
  * @name dispatch#off
  * @function
  * @param {string} Event Name
  */
  dispatch.off = function(event){

    var e = dispatch.events[event];

    // Identifies correct binding method and removes event
    if (dispatch.global.removeEventListener) {
        dispatch.global.removeEventListener(e.ev.type, e.fnc);
    } else {
        dispatch.global.detachEvent(e.ev.type, e.fnc);
    }
    // Remove event from global event object
    delete dispatch.events[event];
  };

  /**
  * Triggers global event
  *
  * @public
  * @name dispatch#trigger
  * @function
  * @param {string} Event Name
  * @param {object} Data
  */
  dispatch.trigger = function(event, data){

    var e = dispatch.events[event];

    e.data = data;

    // Identifies correct trigger method and triggers event
    if (dispatch.global.addEventListener) {
      dispatch.global.dispatchEvent(e.ev);
    } else {
      dispatch.global.fireEvent(e.ev);
    }
  };

  // Return dispatch object
  return dispatch;

})(window.dispatch = window.dispatch || {});
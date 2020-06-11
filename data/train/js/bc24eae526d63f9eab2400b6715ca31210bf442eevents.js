var Promise = require('bluebird');

var constants = require('../constants/events');
var Event = require('../api/event');

function populateEvents() {
  this.dispatch(constants.POPULATE_EVENTS)
  Event
    .all()
    .then((events) => {
      this.dispatch(constants.POPULATE_EVENTS_SUCCESS, { events });
    })
    .catch((error) => {
      this.dispatch(constants.POPULATE_EVENTS_FAILURE, { error });
    });
}

function addEvent(event) {
  this.dispatch(constants.ADD_EVENT)
  Event
    .create(event)
    .then((event) => {
      this.dispatch(constants.ADD_EVENT_SUCCESS, { event });
    })
    .catch((error) => {
      this.dispatch(constants.ADD_EVENT_FAILURE, { error });
    });
}

function editEvent(id, event) {
  this.dispatch(constants.EDIT_EVENT)
  Event
    .update(id, event)
    .then((event) => {
      this.dispatch(constants.EDIT_EVENT_SUCCESS, { id, event });
    })
    .catch((error) => {
      this.dispatch(constants.EDIT_EVENT_FAILURE, { error });
    });
}

function removeEvent(id) {
  this.dispatch(constants.REMOVE_EVENT)
  Event
    .remove(id)
    .then((event) => {
      this.dispatch(constants.REMOVE_EVENT_SUCCESS, { id });
    })
    .catch((error) => {
      this.dispatch(constants.REMOVE_EVENT_FAILURE, { error });
    });
}

function startEnd(start, end) {
  this.dispatch(constants.START_END, { start, end });
}

module.exports = {
  populateEvents,
  addEvent,
  removeEvent,
  editEvent,
  startEnd
}
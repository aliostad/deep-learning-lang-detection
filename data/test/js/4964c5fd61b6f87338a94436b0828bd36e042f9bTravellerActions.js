var alt = require('../alt');

class TravellerActions {
  fetchTrips(token) {
    this.dispatch(token);
  }

  loadingData() {
    this.dispatch();
  }

  fetchedDone(data) {
    this.dispatch(data);
  }

  fetchedFailed(errorMessage) {
    this.dispatch(errorMessage);
  }

  addDestination(destination) {
    this.dispatch(destination);
  }

  postDestinationDone(data) {
    this.dispatch(data);
  }

  postDestinationFailed(errorMessage) {
    this.dispatch(errorMessage);
  }

  toggle(payload) {
    this.dispatch(payload);
  }

  deleteDestination(payload) {
    this.dispatch(payload);
  }
}

module.exports = alt.createActions(TravellerActions);

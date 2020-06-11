var Dispatcher = require("../dispatcher/Dispatcher.js");

var Actions = {
  switchTab: function(tab) {
    Dispatcher.dispatch({
      type: "SWITCH_TAB",
      tab: tab
    });
  },
  loadingLocation: function() {
    Dispatcher.dispatch({
      type: "LOADING_LOCATION"
    });
  },
  gotLocation: function(latitude, longitude) {
    Dispatcher.dispatch({
      type: "GOT_LOCATION",
      latitude: latitude,
      longitude: longitude
    });
  },
  locationFailed: function(msg) {
    Dispatcher.dispatch({
      type: "LOCATION_FAILED",
      msg: msg
    });
  },
  locationUnavailable: function() {
    Dispatcher.dispatch({
      type: "LOCATION_UNAVAILABLE"
    });
  },
  loadingNearbyStations: function() {
    Dispatcher.dispatch({
      type: "LOADING_NEARBY_STATIONS"
    });
  },
  gotNearbyStations: function(stations) {
    Dispatcher.dispatch({
      type: "GOT_NEARBY_STATIONS",
      stations: stations
    });
  },
  loadingLines: function() {
    Dispatcher.dispatch({
      type: "LOADING_LINES"
    });
  },
  gotLines: function(lines) {
    Dispatcher.dispatch({
      type: "GOT_LINES",
      lines: lines
    });
  },
  chooseLine: function(line) {
    Dispatcher.dispatch({
      type: "CHOOSE_LINE",
      line: line
    });
  },
  loadingStations: function() {
    Dispatcher.dispatch({
      type: "LOADING_STATIONS"
    });
  },
  gotStations: function(stations) {
    Dispatcher.dispatch({
      type: "GOT_STATIONS",
      stations: stations
    });
  },
  chooseStation: function(station) {
    Dispatcher.dispatch({
      type: "CHOOSE_STATION",
      station: station
    });
  },
  loadingStation: function() {
    Dispatcher.dispatch({
      type: "LOADING_STATION"
    });
  },
  gotStation: function(station) {
    Dispatcher.dispatch({
      type: "GOT_STATION",
      station: station
    });
  },
  backToLines: function() {
    Dispatcher.dispatch({
      type: "BACK_TO_LINES"
    });
  },
  backToLine: function() {
    Dispatcher.dispatch({
      type: "BACK_TO_LINE"
    });
  },
  loadingStops: function() {
    Dispatcher.dispatch({
      type: "LOADING_STOPS"
    });
  },
  gotStops: function(stations) {
    Dispatcher.dispatch({
      type: "GOT_STOPS",
      stations: stations
    });
  },
  addFavorite: function(stop) {
    Dispatcher.dispatch({
      type: "ADD_FAVORITE",
      stop: stop
    });
  },
  removeFavorite: function(stop) {
    Dispatcher.dispatch({
      type: "REMOVE_FAVORITE",
      stop: stop
    });
  },
  enableLine: function(line) {
    Dispatcher.dispatch({
      type: "ENABLE_LINE",
      line: line
    });
  },
  disableLine: function(line) {
    Dispatcher.dispatch({
      type: "DISABLE_LINE",
      line: line
    });
  }
};

module.exports = Actions;

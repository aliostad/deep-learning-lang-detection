import request from "superagent";
import AppConstants from "../constants/AppConstants.js";
import AppDispatcher from "../dispatcher/AppDispatcher.js";
import LocalStorage from "./LocalStorage.js";

class Api {
  constructor(apiUrl = AppConstants.API_URL) {
    this.url = apiUrl;
    this.pendingRequests = {};
  }

  get(url, successDispatchKey, errorDispatchKey, isTokenRequired = true) {
    this.abortPendingRequests(successDispatchKey);

    var req = request.get(url);

    if(isTokenRequired) {
      req.set("Authorization", `Bearer ${this.token()}`);
    }

    req
    .timeout(AppConstants.TIMEOUT)
    .end((error, response) => {
      this.handleResponse(error, response, successDispatchKey, errorDispatchKey);
    });

    this.pendingRequests[successDispatchKey] = req;
  }

  post(url, params, successDispatchKey, errorDispatchKey, isTokenRequired = true) {
    this.abortPendingRequests(successDispatchKey);

    var req = request.post(url);

    if(isTokenRequired) {
      req.set("Authorization", `Bearer ${this.token()}`);
    }

    req
    .timeout(AppConstants.TIMEOUT)
    .send(params)
    .set("Accept", "application/json")
    .end((error, response) => {
      this.handleResponse(error, response, successDispatchKey, errorDispatchKey, params);
    });

    this.pendingRequests[successDispatchKey] = req;
  }

  put(url, params, successDispatchKey, errorDispatchKey, isTokenRequired = true) {
    this.abortPendingRequests(successDispatchKey);

    var req = request.put(url);

    if(isTokenRequired) {
      req.set("Authorization", `Bearer ${this.token()}`);
    }

    req
    .timeout(AppConstants.TIMEOUT)
    .send(params)
    .set("Accept", "application/json")
    .end((error, response) => {
      this.handleResponse(error, response, successDispatchKey, errorDispatchKey, params);
    });

    this.pendingRequests[successDispatchKey] = req;
  }

  handleResponse(error, response, successDispatchKey, errorDispatchKey) {
    if(error) {
      this.dispatch(errorDispatchKey, error.message);
    } else if(!response.ok) {
      this.dispatch(errorDispatchKey, response.text);
    } else {
      this.dispatch(successDispatchKey, response);
    }
  }

  dispatch(key, response) {
    var payload = {
      actionType: key,
      response: response
    };

    AppDispatcher.dispatch(payload);
  }

  token() {
    return LocalStorage.get(AppConstants.TOKEN);
  }

  abortPendingRequests(key) {
    if(!this.pendingRequests[key]) { return; }

    this.pendingRequests[key]._callback = function(){};
    this.pendingRequests[key].abort();
    this.pendingRequests[key] = null;
  }
}

export default Api;

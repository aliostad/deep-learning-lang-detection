"use strict";
// creates an endpoint with given HTTP method, URL path and dispatch (function)
// (method argument is optional)
// endpoints are evaluated in server.js and
// dispatch(request, response) is called if path/method matches
module.exports = function (method, path, dispatch) {
    var match;

    if (arguments.length < 3) {
        dispatch = path;
        path = method;
        match = function (p) {
            return p === path;
        };
    } else {
        match = function (p, m) {
            return m === method && p === path;
        };
    }

    return {
        match: match,
        dispatch: dispatch
    };
};

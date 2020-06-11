
var default_api_host = window.location.protocol + "//api." + window.location.host;

// checking local host configuration if set
try {
    if (LOCAL_CONFIG && LOCAL_CONFIG.api_host) {
        API_HOST = LOCAL_CONFIG.api_host;
        console.log("Changed API host to '" + API_HOST + "'");
    } else {
        API_HOST = default_api_host;
    }
} catch (e) {
    API_HOST = default_api_host;
}

console.log("Selected " + API_HOST + " as host for API requests");

var APP = angular.module('starter', [
    'ionic',
    'ngCordova'
]);


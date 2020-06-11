/************************************************
* SERVICE.JS
* Description: Defines a single angular service
* Use: Registers service with service module and 
        injects to core module 
*************************************************/

;(function () {
    "use strict";

    angular.module("maps")

    	.service("markers", require("./markers-service.js"))
    	.service("apiSearch", require("./api-search-service.js"))
    	.service("markerHandlers", require("./marker-handlers-service.js"))
    	.service("buttonHandlers", require("./button-handlers-service.js"))
        .service("fetchToken", require("./fetch-token-service.js"))
        .service("localstorage", require("./localstorage-service.js"))
        .service("locationCheck", require("./location-checker-service.js"))
        .service("validate", require("./validate-service.js"))
        .service("menuFind", require("./find-in-menu-service.js"))
        .service("apiResponse", require("./api-response-service.js"));
}());

"use strict";
/**
 * Declares a simple service that adds to numbers
 */
angular.module(APP_NAME).factory('addService', function () {
    // make sure to name your service var the same as the service itself, to aid your IDE
    var addService = {};

    addService.x1 = 0;
    addService.x2 = 0;

    addService.add = function () {
        console.log("addService.add called with x1 = " + addService.x1);
        return addService.x1 + addService.x2;
    };

    addService.addParameters = function (n1, n2) {
        return n1 + n2;
    };

    return addService;
});
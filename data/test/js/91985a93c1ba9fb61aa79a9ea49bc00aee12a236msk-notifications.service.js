angular.module("mishkaBeerApp").factory("$mskNotifications",
    function () {
        var service = {};
        service.error = "";
        service.info = "";
        service.warning = "";
        service.displayError = function (error) {
            service.error = error;
        }
        service.displaySystemError = function () {
            service.error = "common.errors.system";
        }
        service.displayInfo = function (info) {
            service.info = info;
        }
        return service;
    });

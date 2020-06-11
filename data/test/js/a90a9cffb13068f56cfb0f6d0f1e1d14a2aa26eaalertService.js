(function () {
    'use strict';

    angular
    .module('coapp')
    .service('alertService', alertService);

    /**
     *  setup of alert dialog box and functions
     *  to show, set alert message and close alert
     *  dialog box
     *
     *  @ngInject
     */
    function alertService ($timeout) {

        var time = 3500;

        var alertService = this;

        // set some default values on the service
        alertService.alertMessage = "Something Failed";
        alertService.alertType = "danger";
        alertService.showAlert = false;

        alertService.show = function () {
            alertService.showAlert = true;
        }

        alertService.close = function () {
            alertService.showAlert = false;
        }

        alertService.setAlert = function (err) {
            alertService.alertMessage = err;
            alertService.showAlert = true;
            // close alert auto
            $timeout(function () {
                alertService.close();
            }, time);
        }
    }

    alertService.$inject = ['$timeout'];

})();
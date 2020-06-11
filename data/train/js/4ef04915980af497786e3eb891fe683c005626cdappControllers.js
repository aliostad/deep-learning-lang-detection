'use strict';

var angular = require('angular');

var appControllers = angular.module('appControllers', []);

appControllers.controller('mainController', require('./mainController'));
appControllers.controller('paymentInputController', require('./paymentInputController'));
appControllers.controller('readNfcController', require('./readNfcController'));
appControllers.controller('confirmationController', require('./confirmationController'));
appControllers.controller('paymentErrorController', require('./paymentErrorController'));

module.exports = appControllers;

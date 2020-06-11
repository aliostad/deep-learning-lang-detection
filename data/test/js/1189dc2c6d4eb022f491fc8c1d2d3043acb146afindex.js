"use strict";

module.exports = angular.module("tz.controllers", []).
  controller("ApplicationController", ['$scope', '$rootScope', 'Authentification', require("./application_controller")]).
  controller("HomeController", ['$scope', require("./home_controller")]).
  controller("SignupController", ['$scope', '$location', 'User', require("./signup_controller")]).
  controller("SigninController", ['$scope', '$rootScope', '$location', 'Authentification', require("./signin_controller")]).
  controller("SignoutController", ['$rootScope', '$location', 'Authentification', require("./signout_controller")]).
  controller("TimezonesController", ['$scope', '$routeParams', '$timeout', '$location', 'Timezone', require("./timezones_controller")]).
  controller("TimezonesAddController", ['$scope', '$timeout', 'Timezone', require("./timezones-add_controller")]).
  controller("TimezonesEditController", ['$scope', '$timeout', '$routeParams', 'Timezone', require("./timezones-edit_controller")]);

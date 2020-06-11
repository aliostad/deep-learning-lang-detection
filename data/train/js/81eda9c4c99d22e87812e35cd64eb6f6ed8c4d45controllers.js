'use strict';

define(["angular", "app/controllers/HomeController", "app/controllers/EditController", "app/controllers/LoginController", "app/controllers/LogoutController"], function() {
	
	/* Controllers */

	angular.module('scooter.controllers', [])
	
	.controller('HomeController', require("app/controllers/HomeController"))

	.controller('EditController', require("app/controllers/EditController"))

	.controller('LoginController', require("app/controllers/LoginController"))

	.controller('LogoutController', require("app/controllers/LogoutController"))
});
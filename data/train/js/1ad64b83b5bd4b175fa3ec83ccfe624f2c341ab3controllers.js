(function(undefined) {
	"use strict";
	
	define([
			"angular",
			"controllers/DashboardController",
			"controllers/AboutController",
			"controllers/ProfileController",
			"controllers/QuestionController",
			"controllers/RankingController",
			"controllers/AdminController",
		], function(angular, DashboardController, AboutController, ProfileController, QuestionController, RankingController, AdminController) {
			angular.module("siteApp.controllers", ["siteApp.services"])
				.controller("DashboardController", DashboardController)
				.controller("AboutController", AboutController)
				.controller("ProfileController", ProfileController)
				.controller("QuestionController", QuestionController)
				.controller("RankingController", RankingController)
				.controller("AdminController", AdminController);
		});

})();
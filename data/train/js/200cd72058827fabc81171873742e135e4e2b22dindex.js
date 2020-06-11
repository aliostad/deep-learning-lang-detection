var mainApp = angular.module("mainApp", ["ngRoute"]);

mainApp.config(function($routeProvider, $locationProvider){
	$routeProvider.when("/", {
		templateUrl: "templates/home.html",
		controller: "homeController"
	})
	.when("/view1",{
		templateUrl: "templates/view1.html",
		controller: "viewBooksController"
	})
	.when("/view2",{
		templateUrl: "templates/view2.html",
		controller: "manageBooksController"
	})
	.when("/view3", {
		templateUrl: "templates/view3.html",
		controller: "addBookController"
	})
	.when("/view4", {
		templateUrl: "templates/view4.html",
		controller: "viewNotesController"
	})
	.when("/view5", {
		templateUrl: "templates/view5.html",
		controller: "addNoteController"
	})
	.when("/view6", {
		templateUrl: "templates/view6.html",
		controller: "viewNoteController"
	})
	.otherwise({redirectTo: "/"});

	$locationProvider.html5Mode(true);
});

mainApp.controller("homeController", function(){});
mainApp.controller("viewBooksController", function(){});
mainApp.controller("manageBooksController", function(){});
mainApp.controller("addBookController", function(){});
mainApp.controller("viewNotesController", function(){});
mainApp.controller("addNoteController", function(){});
mainApp.controller("viewNoteController", function(){});

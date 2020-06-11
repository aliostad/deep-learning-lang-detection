var appBreweries=angular.module("BreweriesApp", []).
controller("BreweriesController", ["$scope","rest","$timeout","$location","config","$route","save",require("./breweriesController")]).
controller("BreweryAddController",["$scope","config","$location","rest","save","$document","modalService",require("./breweryAddController")]).
controller("BreweryUpdateController",["$scope","config","$location","rest","save","$document","modalService","$controller",require("./breweryUpdateController")]);
module.exports=angular.module("BreweriesApp").name;
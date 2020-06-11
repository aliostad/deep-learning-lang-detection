var appBeers=angular.module("BeersApp", []).
controller("BeerDetailsController",["$scope","config","$location",require("./beerDetailsController")]).
controller("BeersController", ["$scope","rest","$timeout","$location","config","$route","save",require("./beersController")]).
controller("BeerAddController",["$scope","config","$location","rest","save","$document","modalService",require("./beerAddController")]).
controller("BeerUpdateController",["$scope","config","$location","rest","save","$document","modalService","$controller",require("./beerUpdateController")]);
module.exports=angular.module("BeersApp").name;
/**
 * 
 */

define([ "controllers/home-controller", "controllers/aboutus-controller", "controllers/car-controller", "controllers/user-controller", "controllers/train-controller", "controllers/railway-station-controller" ], function(homeController, aboutUsController, carController, userController,
        trainController, railwayStationController) {

    'use strict';

    /* Services */

    var AppController = angular.module('AngularSpringApp.controllers', []);

    AppController.controller("HomeController", homeController);
    AppController.controller("CarController", carController);
    AppController.controller("UserController", userController);
    AppController.controller("RailwayStationController", railwayStationController);
    AppController.controller("TrainController", trainController);
    AppController.controller("AboutUsController", aboutUsController);

    return AppController.name;
});

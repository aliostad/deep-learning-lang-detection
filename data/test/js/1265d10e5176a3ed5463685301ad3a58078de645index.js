/** attach controllers to this module 
 * if you get 'unknown {x}Provider' errors from angular, be sure they are
 * properly referenced in one of the module dependencies in the array.
 * below, you can see we bring in our services and constants modules 
 * which avails each controller of, for example, the `config` constants object.
 **/
define([
    './loginController'
    ,'./basicDetController'
    ,'./dashboardController'
    ,'./SchemaGeneratorController'
    ,'./naviController'
    ,'./signupController'
    ,'./keyBoardController'
], function (loginController,basicDetController,dashboardController,SchemaGeneratorController,naviController,signupController,keyBoardController) {
    'use strict';

    console.log(angular);

    var controllers= angular.module('controllers', []);
        controllers.controller("loginController",loginController);
        controllers.controller("dashboardController",dashboardController);
        controllers.controller("basicDetController",basicDetController);
        controllers.controller("SchemaGeneratorController",SchemaGeneratorController);
        controllers.controller("naviController",naviController);
        controllers.controller("signupController",signupController);
        controllers.controller("keyBoardController",keyBoardController);
  

    return controllers;
});
/*global define, angular, list of controllers*/
define([
    "./controllers/member.controller",
    "./controllers/home.controller",
    "./controllers/programs.controller",
    "./controllers/filleuls.controller" ,
    "./controllers/compte.controller", 
    "./controllers/points.controller" 
], function (MemberController, HomeController, ProgramsController, FilleulsController, CompteController, PointsController) {
    "use strict";
    var controllersModuleName = "member.controllers";
    angular.module(controllersModuleName, [])
        .controller("MemberController", MemberController)
        .controller("HomeController", HomeController)
        .controller("ProgramsController", ProgramsController)
    .controller("FilleulsController", FilleulsController)
    .controller("CompteController", CompteController)
    .controller("PointsController", PointsController);

    return controllersModuleName;
});
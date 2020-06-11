angular.module("Boards",["ngRoute"])
.controller("MainController",[require("./controllers/mainController")])
.controller("LoginController",["DAOService",require("./controllers/loginController")])
.controller("ProjectsController",["DAOService",require("./controllers/projectsController")])
.controller("ProjectController",["DAOService","$routeParams",require("./controllers/projectController")])
.controller("StoryController",["DAOService","$routeParams",require("./controllers/storyController")])
.config(['$sceDelegateProvider','$routeProvider','$locationProvider',require("./config")])
.service("DAOService",["$http",require("./services/daoService")]);
"use strict";

//import { MainController } from './MainController';
var RootController = require("./RootController").RootController;
var LoginController = require("./LoginController").LoginController;
var MainController = require("./MainController").MainController;
var RestService = require("./RestService").RestService;
var Run = require("./Run").Run;
var Config = require("./Config").Config;


angular.module("TheGazApp", ["ionic", "ngCordova"]).controller("RootController", RootController).controller("LoginController", LoginController).controller("MainController", MainController).service("RestService", RestService).config(Config).run(Run);
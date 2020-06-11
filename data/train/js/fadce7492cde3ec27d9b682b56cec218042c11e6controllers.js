var moduleName = "ngApp.controllers";

import incidentsController from './controller/incidents-controller.js';
import settingsController from './controller/settings-controller.js';
import checkAuthedController from './controller/check-authed-controller.js';
import topnavController from './controller/topnav-controller.js';
import loginController from './controller/login-controller.js';

var ctrls = Array.from([
    incidentsController,
    settingsController,
    checkAuthedController,
    topnavController,
    loginController
]);

var app = angular.module(moduleName, []);

for(var ctrl of ctrls){
    app.controller(ctrl.name, ctrl.def);
}

export default moduleName;
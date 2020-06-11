import { appController } from '/controllers/AppController.js';
import { loginController } from '/controllers/LoginController.js';
import { registerController } from '/controllers/RegisterController.js';

var controllers = {
  moduleName : 'app.controllers',
  appController : appController,
  loginController : loginController,
  registerController : registerController,
  statsController : statsController
};

angular.module(controllers.moduleName, [])
  .controller(appController.moduleName, appController.controller)
  .controller(loginController.moduleName, loginController.controller)
  .controller(registerController.moduleName, registerController.controller)
  .controller(statsController.moduleName, statsController.controller);

export var controllers = controllers;

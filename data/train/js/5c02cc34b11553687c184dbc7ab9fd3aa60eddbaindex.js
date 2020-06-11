import angular from 'angular';

import SignupController from './controllers/signup.controller';
import LoginController from './controllers/login.controller';
// import LogoutController from './controllers/logout.controller';

import SignupService from './services/signup.service';
import LoginService from './services/login.service';
import AuthService from './services/auth.service.js';

angular
  .module('app.auth', [])
  .controller('SignupController', SignupController)
  .controller('LoginController', LoginController)
  // .controller('LogoutController', LogoutController)
  .service('SignupService', SignupService)
  .service('LoginService', LoginService)
  .service('AuthService', AuthService)
;
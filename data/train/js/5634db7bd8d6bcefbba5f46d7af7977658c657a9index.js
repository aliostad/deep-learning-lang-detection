import angular from 'angular';

import LoginController from './controllers/login.controller';
import SignupController from './controllers/signup.controller';
import ProfileController from './controllers/profile.controller';

import profileItem from './directives/profile.directive';

import UserService from './services/user.service';
import ProfileService from './services/profile.service';

angular
  .module('app.user', ['app.core'])
  .controller('SignupController', SignupController)
  .controller('LoginController', LoginController)
  .controller('ProfileController', ProfileController)
  .directive('profileItem', profileItem)
  .service('UserService', UserService)
  .service('ProfileService', ProfileService)
  ;
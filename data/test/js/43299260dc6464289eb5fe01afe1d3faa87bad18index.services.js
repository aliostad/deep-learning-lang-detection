import params from './index.params';
import UserService from './services/user.service';
import LocaleService from './services/locale.service';
import SessionService from './services/session.service';
import RegistrationService from './services/registration.service';

angular.module('blogAngularExample.services', [])
  .value('params', params)
  .service('SessionService', SessionService)
  .service('RegistrationService', RegistrationService)
  .service('UserService', UserService)
  .service('LocaleService', LocaleService);


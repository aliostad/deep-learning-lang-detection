import * as angular from 'angular';

import 'angularfire';

import AlertService from './alert.service';
import GameService from './game.service';
import UserService from './user.service';
import FirebaseService from './firebase.service';

const servicesModule = angular.module('thinker.services', [
    'firebase',
]);

servicesModule.service('AlertService', AlertService);
servicesModule.service('GameService', GameService);
servicesModule.service('UserService', UserService);
servicesModule.service('FirebaseService', FirebaseService);

export default servicesModule;

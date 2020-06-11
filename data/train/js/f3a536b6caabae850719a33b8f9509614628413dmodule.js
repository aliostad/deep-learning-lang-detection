import angular from 'angular';

import configModule from '../app-config';

import openFdaService from './open-fda-service';
import foodRecallService from './food-recall-service';
import cacheService from './cache-service';
import localStorageService from './local-storage-service';

export default angular.module('fdaFoodRecalls.services', [ configModule.name ])
  .service('openFdaService', openFdaService)
  .service('foodRecallService', foodRecallService)
  .service('cacheService', cacheService)
  .service('localStorageService', localStorageService)
;

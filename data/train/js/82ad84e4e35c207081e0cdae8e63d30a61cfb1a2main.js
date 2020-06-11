import angular from 'angular';
import 'angular-ui-router';

import config from './config';

import HomeController from './controllers/homeController';
import SoundCloudController from './controllers/soundcloudController';
import ListController from './controllers/listController';
import SingleController from './controllers/singleController';
import AddController from './controllers/addController';
import EditController from './controllers/editController';

import WhiskeyService from './services/whiskey.service';


//register a model
angular
  .module('app', ['ui.router'])
  .constant('SC', '8927a65b926a9001bc02f4277da049d4')
  .constant('PARSE', {
    URL: 'https://api.parse.com/1/',
    CONFIG: {
      headers: {
        'X-Parse-Application-Id': 'Zjgd8YOOQKK2HPOQwRyMb3EaKTlcHXwQCmAHZHIQ',
        'X-Parse-REST-API-Key'  : '1jJcNv5MA3D6GILJEIN7D546CFyZHHUidUqEblxX'
      }
    }
  })
  .config(config)
  .controller('HomeController', HomeController)
  .controller('SoundCloudController', SoundCloudController)
  .controller('ListController', ListController)
  .controller('SingleController', SingleController)
  .controller('AddController', AddController)
  .controller('EditController', EditController)
  .service('WhiskeyService', WhiskeyService)
  ;
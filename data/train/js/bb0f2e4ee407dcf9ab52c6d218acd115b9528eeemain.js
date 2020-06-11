import angular from 'angular';
import 'angular-ui-router';
import 'angular-foundation';
import moment from 'moment';

import config from './config';

import HomeController from './controllers/home.controller';
import ExploreController from './controllers/explore.controller';
import RegisterController from './controllers/register.controller';
import SignInController from './controllers/signIn.controller';
import UploadController from './controllers/upload.controller';
import UserController from './controllers/user.controller';
import LogOutController from './controllers/logout.controller';
import SingleController from './controllers/single.controller';
import EditController from './controllers/edit.controller';

import PostService from './services/post.service';

angular
  .module('app', ['ui.router', 'mm.foundation'])
  .constant('PARSE', {
    URL: 'https://api.parse.com/1/',
    CONFIG: {
      headers: {
        'X-Parse-Application-Id': 'mdglKarlt2mNMLydQkIsP6cDMJMQiszcRUrxLqkd',
        'X-Parse-REST-API-Key': 'tRuPjdevHeUJT6biDyeadniIR4L8SHp5RAuYwJJy'
      }
    }
  })
  .config(config)
  .controller('HomeController', HomeController)
  .controller('ExploreController', ExploreController)
  .controller('RegisterController', RegisterController)
  .controller('SignInController', SignInController)
  .controller('UploadController', UploadController)
  .controller('UserController', UserController)
  .controller('LogOutController', LogOutController)
  .controller('SingleController', SingleController)
  .controller('EditController', EditController)
  .service('PostService', PostService)
;
import {Router} from 'director';
import $ from 'jquery';
import bootstrap from 'bootstrap';

import ControllerBase from './ControllerBase';
import LandingController from './LandingController';
import UserController from './UserController';
import SiteController from './SiteController';
import GraphController from './GraphController';


window.runApplication = function (apiUrl) {
  var router = new Router().init();

  ControllerBase.apiUrl = apiUrl;
  new LandingController(router);
  new UserController(router);
  new SiteController(router);
  new GraphController(router);
  
  router.handler();
};
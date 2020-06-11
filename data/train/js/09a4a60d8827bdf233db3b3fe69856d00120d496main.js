import angular from 'angular';
import 'angular-ui-router';
import jquery from 'jquery';
import configFunct from './config';

import RootController from './controllers/root.controller';
import ResumeController from './controllers/resume.controller';
import WorkController from './controllers/work.controller';





angular
  .module('app', ['ui.router'])
  .config(configFunct)
  .controller('WorkController', WorkController)
  .controller('ResumeController', ResumeController)
  .controller('RootController', RootController)

  ;







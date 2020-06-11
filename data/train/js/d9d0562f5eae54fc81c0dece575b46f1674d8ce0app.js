'use strict';

require('angular');
require('angular-route');

var Log                   = require('./config/Log');
var Route                 = require('./config/Route');

var snippet               = require('./directives/snippet');

var PageController        = require('./controllers/PageController');
var MainController        = require('./controllers/MainController');
var FrontMvcController    = require('./controllers/FrontMvcController');
var SpaController         = require('./controllers/SpaController');
var FrameworkController   = require('./controllers/FrameworkController');
var ProsConsController    = require('./controllers/ProsConsController');
var DataBindingController = require('./controllers/DataBindingController');
var ServiceController     = require('./controllers/ServiceController');
var DiController          = require('./controllers/DiController');


angular.module('app.sharing', [ 'ngRoute' ])
    .config(Log)
    .config(Route)
    .directive('snippet', snippet)
    .controller('PageController', PageController)
    .controller('MainController', MainController)
    .controller('FrontMvcController', FrontMvcController)
    .controller('SpaController', SpaController)
    .controller('FrameworkController', FrameworkController)
    .controller('ProsConsController', ProsConsController)
    .controller('DataBindingController', DataBindingController)
    .controller('ServiceController', ServiceController)
    .controller('DiController', DiController);

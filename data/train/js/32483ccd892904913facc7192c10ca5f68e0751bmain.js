'use strict';

angular
    .module('killerApp', ['ui.router', 'webStorageModule', 'killerService','pascalprecht.translate'])
    .config(['$stateProvider', '$urlRouterProvider', require('./config/routes')])
    .config(['$translateProvider', require('./config/en')])
    .config(['$translateProvider', require('./config/he')])
    .controller('homeController', require('./controllers/homeController'))
    .controller('playersController', require('./controllers/playersController'))
    .controller('revealingNamesController', require('./controllers/revealingNamesController'))
    .controller('revealingTasksController', require('./controllers/revealingTasksController'))
    .controller('gameOnController', require('./controllers/gameOnController'))
    .controller('gameOverController', require('./controllers/gameOverController'))
    .controller('bodyController', require('./controllers/body'))
    .service('killService', require('./services/killerService'));
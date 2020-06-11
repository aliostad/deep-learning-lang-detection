define([
    'angular',
    'pages/home/players-list.controller',
    'pages/home/player-stats.controller',
    'pages/login/login.controller'
],  function(ng, playersListController, playerStatsController, loginController) {
        'use strict';
        
        return ng.module('pagesModule', [])
                 .controller('pages.playersListController', playersListController)
                 .controller('pages.playerStatsController', playerStatsController)
                 .controller('pages.loginController', loginController);
    }
);
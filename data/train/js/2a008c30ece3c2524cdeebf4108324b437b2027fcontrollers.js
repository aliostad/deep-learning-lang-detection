(function(define, angular) {

    'use strict';

    var dependencies = [
        'controllers/MainController',
        'controllers/BeerYouController',
        'controllers/BeerMeController',
        'controllers/SendController',
        'controllers/PayController',
        'controllers/ReceiveController'
    ];

    define(dependencies, function() {

        angular.module('app.controllers', [])
            .controller('MainController', require('controllers/MainController'))
            .controller('BeerYouController', require('controllers/BeerYouController'))
            .controller('BeerMeController', require('controllers/BeerMeController'))
            .controller('SendController', require('controllers/SendController'))
            .controller('PayController', require('controllers/PayController'))
            .controller('ReceiveController', require('controllers/ReceiveController'));

    });

}(define, angular));

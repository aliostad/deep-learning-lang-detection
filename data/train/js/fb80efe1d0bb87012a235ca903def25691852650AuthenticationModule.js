/**
 * ******************************************************************************************************
 *
 *   QuizModule
 *
 *   Defines controllers and services for the Authentication Module Quiz
 *
 * ******************************************************************************************************
 */

(function ( define, angular ) {
    "use strict";

    define([
            'cont/LoginController',
            'utils/constants',
            'cont/HomeController',
            'cont/SaveItController',
            'cont/BartItController'
        ],
        function ( LoginController, Constants, HomeController, SaveItController,BartItController  )
        {
            var moduleName = "true.barter.Authenticate";

            angular
                .module(moduleName, [ ])
                .controller("LoginController" , LoginController )
                .controller("HomeController" , HomeController )
                .controller("SaveItController" , SaveItController )
                .controller("BartItController" , BartItController );

            return moduleName;
        });

}( define, angular ));


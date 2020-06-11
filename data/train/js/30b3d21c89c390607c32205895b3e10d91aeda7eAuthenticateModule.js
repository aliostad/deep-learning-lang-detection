/**
 * ******************************************************************************************************
 *
 *   
 *
 *   Defines controllers and services for the Authentication Module 
 *
 * 
 *
 * ******************************************************************************************************
 */

(function ( define, angular ) {
    "use strict";

    define([
            'user/controllers/AuthenticationController',
            'user/controllers/MainController'
            
        ],
        function ( AuthenticationController, MainController )
        {
            var moduleName = "mybkr.authenticate";

            angular
                .module(     moduleName,    [ ] )
                .controller( "AuthenticationController", AuthenticationController )
                .controller( "MainController", MainController ); 

            return moduleName;
        });


}( define, angular ));


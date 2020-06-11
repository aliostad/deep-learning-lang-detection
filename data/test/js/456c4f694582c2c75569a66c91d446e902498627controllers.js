(function ( define ) {
    "use strict";

    define(['angular',
            'controllers/AccountsController',
            'controllers/LoginController',
            'controllers/LogoutController',
            'controllers/MainController',
            'controllers/NewAccountController'
        ],
        function ( angular, AccountsController, LoginController, LogoutController, MainController, NewAccountController )
        {
            var moduleName = "contacts.controllers";

            angular.module( moduleName, [] )
              .controller( "AccountsController",   AccountsController )
              .controller( "LoginController",      LoginController )
              .controller( "LogoutController",     LogoutController )
              .controller( "MainController",       MainController )
              .controller( "NewAccountController", NewAccountController );

            return moduleName;
        });

}( define ));

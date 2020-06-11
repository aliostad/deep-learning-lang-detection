// Register Modules

(function ( define ) {
    "use strict";

    define([  'angular'
            , 'controller/appController'
            , 'controller/homeController'
            , 'controller/footerController'
            , 'controller/aboutController'
            , 'controller/eventController'
            , 'controller/participantsController'
            , 'framework/delegate/appDelegate'
            , 'framework/manager/eventManager'

        ],
        function (    angular
                    , appController
                    , homeController
                    , footerController
                    , aboutController
                    , eventController
                    , participantsController
                    , appDelegate
                    , eventManager
                 )
        {
            var moduleName = "app.modules";
            angular.module(moduleName,[])

                // Services
                  .service( "appDelegate", appDelegate)
                  .service( "eventManager", eventManager)


                // Controllers
                .controller( "appController", appController)
                .controller( "homeController", homeController)
                .controller( "footerController", footerController)
                .controller( "aboutController", aboutController)
                .controller( "eventController", eventController)
                .controller( "participantsController", participantsController)
                ;

            console.log("Modules Loaded");

            return moduleName;
        });

}( define));

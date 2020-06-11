/**
 * ******************************************************************************************************
 *
 *   
 *
 *   Defines controllers and services for the TeacherModule 
 *
 *
 * ******************************************************************************************************
 */

(function ( define, angular ) {
    "use strict";

    define([
           "teacher/controllers/MainController",
           "teacher/controllers/SalesAdminDashboardController"
           
           
            
        ],
        function ( MainController, SalesAdminDashboardController)
        {
            var moduleName = "TNT.Parent";

            angular
                .module(     moduleName,    [ ] )
                .controller("MainController",MainController)
                .controller("SalesAdminDashboardController",SalesAdminDashboardController);
                
               

            return moduleName;
        });


}( define, angular ));


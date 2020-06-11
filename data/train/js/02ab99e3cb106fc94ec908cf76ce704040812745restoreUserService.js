(function () {
    'use strict';

    var serviceId = 'restoreUserService';

    // TODO: replace app with your module name
    angular.module('app.security')
        .factory(serviceId, ['$location','$q', 'storageService', 'appActivityService', 'userService', restoreUserService]);

    function restoreUserService($location, $q, storageService, appActivityService, userService) {        

        var service = {
            restore: restore
        };

        return service;

        function restore() {
            appActivityService.busy("restoreUserService");

            if (storageService.retrieve("accessToken")) {
                return userService.getUserInfo().then(
                      function (result) {
                          if (result.hasRegistered) {
                              userService.setUser(result);
                              appActivityService.idle("restoreUserService");                                                    
                          } else {
                              appActivityService.idle("restoreUserService");
                              $location.path("/signIn");
                          }                       
                      },
                      function (result) {
                          //error	                     
                          appActivityService.idle("restoreUserService");
                          $location.path("/signIn");                          
                      });
            } else {
                return $q(function (resolve, reject) {
                    appActivityService.idle("restoreUserService");
                    resolve(false);
                });                
            }
            
        }
    }
})();
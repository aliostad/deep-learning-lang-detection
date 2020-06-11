 (function() {
     'use strict';

     /**
      * Get Shared module.
      */
     angular.module(appName)

     /**
      * Registration data service.
      */
     .factory('LoginDataService', LoginDataService)

     .factory('LoginClientDataService', LoginClientDataService)

     .factory('LoginPersistenceDataService', LoginPersistenceDataService);

     LoginDataService.$inject = ['LoginClientDataService'];

     function LoginDataService(LoginClientDataService) {
         var loginDataService = {

         };

        return loginDataService;
     }

     LoginClientDataService.$inject = ['$q', 'config'];

     function LoginClientDataService($q, config) {
         var loginClientDataService = {
         };
         return loginClientDataService;
     }

     LoginPersistenceDataService.$inject = [];

     function LoginPersistenceDataService() {
         var loginPersistenceDataService = {};
         return loginPersistenceDataService;
     }
 })();
(function () {
    "use strict";
    angular.module(APPNAME)
        .factory("userService", UserServiceFactory);
    UserServiceFactory.$inject = ["$baseService", "$sabio"];

    function UserServiceFactory($baseService
                                    , $sabio) {
        var aSabioServiceObject = sabio.services.user;
        var newService = $baseService.merge(true, {}, aSabioServiceObject, $baseService)
        console.log("user service", aSabioServiceObject);

        return newService;
    }
})();
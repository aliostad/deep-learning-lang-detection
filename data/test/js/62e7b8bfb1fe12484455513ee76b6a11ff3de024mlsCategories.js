(function () {

    "use strict";

    angular.module(APPNAME)
        .factory("mlsCategoriesService", MlsCategoriesServiceFactory);

    MlsCategoriesServiceFactory.$inject = ["$baseService", "$sabio"];

    function MlsCategoriesServiceFactory($baseService, $sabio) {
        var aSabioServiceObject = sabio.services.mlscategories;
        var newService = $baseService.merge(true, {}, aSabioServiceObject, $baseService);
        console.log('mlscategories service', aSabioServiceObject);
        return newService;
    }

})();
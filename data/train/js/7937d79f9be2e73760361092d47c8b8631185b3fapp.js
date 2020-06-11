angular.module('wotpro', [])

    .controller('VehicleCollectionCtrl', ['$scope', 'vehicleApi', VehicleCollectionCtrl])
    .controller('VehicleDetailsCollectionCtrl', ['$scope', 'vehicleApi', 'gunApi', 'engineApi', 'radioApi', 'suspensionApi', 'turretApi', VehicleDetailsCollectionCtrl])

    .factory('apiSettings', ['$rootScope', 'apiClientId', function ($rootScope, apiClientId) {
        return new ApiSettings($rootScope.translation, apiClientId);
    }])
    .factory('vehicleApi', ['$http', 'apiSettings', function ($http, apiSettings) {
        return new VehicleApi($http, apiSettings);
    }])
    .factory('gunApi', ['$http', 'apiSettings', function ($http, apiSettings) {
        return new GunApi($http, apiSettings);
    }])
    .factory('engineApi', ['$http', 'apiSettings', function ($http, apiSettings) {
        return new EngineApi($http, apiSettings);
    }])
    .factory('radioApi', ['$http', 'apiSettings', function ($http, apiSettings) {
        return new RadioApi($http, apiSettings);
    }])
    .factory('suspensionApi', ['$http', 'apiSettings', function ($http, apiSettings) {
        return new SuspensionApi($http, apiSettings);
    }])
    .factory('turretApi', ['$http', 'apiSettings', function ($http, apiSettings) {
        return new TurretApi($http, apiSettings);
    }])

    .filter('inArray', function () {
        return InArrayFilter;
    })
    .filter('unique', function () {
        return UniqueFilter;
    })
    .filter('orderByVehicleType', function () {
        return OrderByVehicleType;
    })
    .filter('orderByGun', function () {
        return OrderByGun;
    })

    .value('apiClientId', 'demo')

    .run(['$rootScope', '$http', function ($rootScope, $http) {
        var $scope = $rootScope.$new();
        new TranslationService($scope, $http);
        $rootScope.translation = $scope;
    }]);

app.controller('ServicePropertiesController', function ($scope,
                                                        ServiceProperties,
                                                        selectedService) {

    $scope.selectedService = selectedService;

    $scope.editService = function (service) {
        ServiceProperties.updateService(service);
    };

    $scope.deleteEndpoint = function (endpoint) {
        ServiceProperties.removeEndPoint($scope.selectedService, endpoint);
    };

    $scope.addNewEndpoint = function () {
        ServiceProperties.addNewEndpoint($scope.selectedService);
    };
});

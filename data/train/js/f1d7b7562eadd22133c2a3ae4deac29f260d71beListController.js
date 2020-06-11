define([
    'angularAMD',
    'ServiceService',
    'footable'
    ], function(angularAMD) {

    angularAMD.controller('ServiceListController', ['$scope', '$stateParams', 'ServiceService',
        function( $scope, $stateParams, serviceService ) {

            serviceService.getServicesGridList(function (err, data) {
                $scope.services = data;
            });

            $scope.tofggleShowParentServices = function(index){
                $scope.services[index].isVisible = !$scope.services[index].isVisible;
            };

            $scope.toggleStatus = function (service) {
                serviceService.toggleServiceStatus(service, function (err, updatedService) {
                    service.isActive = updatedService.isActive;
                });
            }

    }]);
});
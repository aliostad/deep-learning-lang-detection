angular.module('dockerSpawnerApp').controller('ServicesCtrl', function($scope, Service, $state) {

    $scope.loadingData = false;

    $scope.updateList = function() {
        $scope.loadingData = true;
        $scope.services = Service.query();
        $scope.services.$promise.then(function() {
            $scope.loadingData = false;
        });
    };
    $scope.updateList();


    $scope.addService = function() {
        if ($scope.addingService) {
            return;
        }

        $scope.addingService = true;
        var service = new Service();
        service.$save()
            .then(function() {
                $scope.addingService = false;
                $state.go("service", {serviceId: service._id});
            }).catch(function(result) {
                $scope.addingService = false;
                window.alert(result.data);
            });
    };
});

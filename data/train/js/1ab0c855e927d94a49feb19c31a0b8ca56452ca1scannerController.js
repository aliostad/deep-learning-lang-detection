function scannerController($scope, configService, authService, permService,
        modelService) {
    $scope.config = configService, $scope.name = 'scanner';

    /**
     * models in play here.
     * 
     * @todo inject models, using array of strings maybe.
     */
    $scope.DomainProfile = authService.getDomainProfile();

    $scope.init = function() {
        authService.authenticate($scope).then(function() {
        }, function(err) {

        });
    }
}

scannerController.$inject = [
        '$scope', 'configService', 'authService', 'permService', 'modelService'
];
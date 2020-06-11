var serviceModule = angular.module('Service', []);

var Model = function(http) {
    var self = this;

    this.Results = [];

    this.GetResults = function () {
        http.get('/api/ServiceResults').success(function(data, status, header, config) {
            self.Results = angular.fromJson(data);
        });
    };
};

serviceModule.service('ServiceService', ['$http', function(http) {
    var model = new Model(http);
    return model;
}]);

serviceModule.controller('ServiceController', ['ServiceService','$scope', function(service,$scope) {
    $scope.Model = service;
    $scope.Model.GetResults();
}]);
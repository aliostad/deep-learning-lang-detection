'use strict';

shopstuffsApp.controller('ServiceController', function ($scope, Service) {

        $scope.services = Service.query();

        $scope.create = function () {
            Service.save($scope.service,
                function () {
                    $scope.services = Service.query();
                    $('#saveServiceModal').modal('hide');
                    $scope.clear();
                });
        };

        $scope.update = function (id) {
            $scope.service = Service.get({id: id});
            $('#saveServiceModal').modal('show');
        };

        $scope.delete = function (id) {
            Service.delete({id: id},
                function () {
                    $scope.services = Service.query();
                });
        };

        $scope.clear = function () {
            $scope.service = {id: null, name: null, description: null};
        };
    });

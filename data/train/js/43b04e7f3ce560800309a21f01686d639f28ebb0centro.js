"use strict";
app.config(['crudRoutesProvider', function (crudRoutesProvider) {
        crudRoutesProvider.addAllRoutes({
            entity: "Centro",
            expand: "direccion.municipio,direccion.municipio.provincia"
        });
    }]);

app.controller("CentroSearchController", ['$scope', 'genericControllerCrudList', 'controllerParams', function ($scope, genericControllerCrudList, controllerParams) {
        genericControllerCrudList.extendScope($scope, controllerParams);
        $scope.page.pageSize = 20;

        $scope.filters.$ne.idCentro=-1; 

        $scope.search();
    }]);


app.controller("CentroNewEditController", ['$scope', 'genericControllerCrudDetail', 'controllerParams', function ($scope, genericControllerCrudDetail, controllerParams) {
        genericControllerCrudDetail.extendScope($scope, controllerParams);
    }]);

app.controller("CentroViewController", ['$scope', 'genericControllerCrudDetail', 'controllerParams', function ($scope, genericControllerCrudDetail, controllerParams) {
        genericControllerCrudDetail.extendScope($scope, controllerParams);
    }]);

app.controller("CentroDeleteController", ['$scope', 'genericControllerCrudDetail', 'controllerParams', function ($scope, genericControllerCrudDetail, controllerParams) {
        genericControllerCrudDetail.extendScope($scope, controllerParams);
    }]);
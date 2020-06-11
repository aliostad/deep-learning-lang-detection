"use strict";
app.config(['crudRoutesProvider', function (crudRoutesProvider) {
        crudRoutesProvider.addAllRoutes({
            entity:"ExperienciaLaboral",
            crudName:"curriculum.ExperienciaLaboral"
        });
    }]);

app.controller("CurriculumExperienciaLaboralSearchController", ['$scope', 'genericControllerCrudList', 'controllerParams', function ($scope, genericControllerCrudList, controllerParams) {
        genericControllerCrudList.extendScope($scope, controllerParams);

        $scope.orderby=[
            {fieldName:"fechaInicio",orderDirection:"ASC"}
        ];

        $scope.search();
    }]);

app.controller("CurriculumExperienciaLaboralNewEditController", ['$scope', 'genericControllerCrudDetail', 'controllerParams', function ($scope, genericControllerCrudDetail, controllerParams) {
        genericControllerCrudDetail.extendScope($scope, controllerParams);
    }]);

app.controller("CurriculumExperienciaLaboralViewController", ['$scope', 'genericControllerCrudDetail', 'controllerParams', function ($scope, genericControllerCrudDetail, controllerParams) {
        genericControllerCrudDetail.extendScope($scope, controllerParams);
    }]);

app.controller("CurriculumExperienciaLaboralDeleteController", ['$scope', 'genericControllerCrudDetail', 'controllerParams', function ($scope, genericControllerCrudDetail, controllerParams) {
        genericControllerCrudDetail.extendScope($scope, controllerParams);
    }]);
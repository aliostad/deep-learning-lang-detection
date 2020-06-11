'use strict';

export default class TypeSelect {
    constructor($scope, securityService, CaseService, strataService, AlertService) {
        'ngInject';

        $scope.securityService = securityService;
        $scope.CaseService = CaseService;
        $scope.typesLoading = true;
        strataService.values.cases.types().then(function (types) {
            $scope.typesLoading = false;
            CaseService.types = types;
        }, function (error) {
            $scope.typesLoading = false;
            AlertService.addStrataErrorMessage(error);
        });
    }
}

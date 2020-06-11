'use strict';

export default class GroupSelect {
    constructor($scope, securityService, SearchCaseService, CaseService, CASE_GROUPS) {
        'ngInject';

        $scope.securityService = securityService;
        $scope.SearchCaseService = SearchCaseService;
        $scope.CaseService = CaseService;
        $scope.CASE_GROUPS = CASE_GROUPS;

        $scope.setSearchOptions = function (showsearchoptions) {
            CaseService.showsearchoptions = showsearchoptions;
            CaseService.buildGroupOptions();
        };
    }
}

(function () {
    'use strict';
    angular.module('war.commons')
        .factory('commonFactories', CommonFactories);
    CommonFactories.$inject = ['yearService', 'monthService', 'educationLevelService', 'relationshipTypeService'];
    function CommonFactories(yearService, monthService, educationLevelService, relationshipTypeService) {
        return {
            yearService: yearService,
            monthService: monthService,
            educationLevelService: educationLevelService,
            relationshipTypeService: relationshipTypeService
        };
    }

})();

(function() {
    'use strict';
    angular.module('module.service').service('activityService', activityService);

    activityService.$inject = ['$state', '$resourceService', 'storageService'];

    function activityService($state, $resourceService, storageService) {
        return {
            empĺoyee: {
                list: list
            }
        };

        function list(query, fnSuccess, fnError) {
            var employeeList = $resourceService.request('employeeList');
            return employeeList.get(query, fnSuccess, fnError);
        }
    }
})();

(function () {

    'use strict';

    var moduleId = 'mainDataService';
    var serviceId = '$dataService';

    angular.module(moduleId).service(serviceId, dataService);

    dataService.$inject = [
        'usersDataService'
        , 'rolesDataService'
        , 'testDataService'
    ];

    function dataService(
        usersDataService
        , rolesDataService
        , testDataService
        ) {
        //users data service
        this.users = usersDataService;
        //roles data service
        this.roles = rolesDataService;
        this.test = testDataService;
    }

})();
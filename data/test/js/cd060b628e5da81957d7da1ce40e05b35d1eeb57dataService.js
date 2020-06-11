'use strict';

define(['app', 'agendoApp/services/customersBreezeService',
        'agendoApp/services/customersService'], function (app) {

    var injectParams = ['config', 'customersService', 'customersBreezeService'];

    var dataService = function (config, customersService, customersBreezeService) {
        return (config.useBreeze) ? customersBreezeService : customersService;
    };

    dataService.$inject = injectParams;

    app.factory('dataService',
        ['config', 'customersService', 'customersBreezeService', dataService]);

        });

//define(['app', 'agendoApp/services/serv/servServices'], function (app) {

//    var injectParams = ['config', 'servServices'];

//    var dataservService = function (config, servServices) {
//            return servServices;
//            };

//             dataservService.$inject = injectParams;

//            app.factory('dataservService',
//                ['servServices', dataservService]);

//        });



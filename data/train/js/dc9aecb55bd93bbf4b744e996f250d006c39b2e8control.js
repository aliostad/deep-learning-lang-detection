define(['Route', 'queryController', 'nameController', 'insertController', 'readController'],
    function(Route, queryController, nameController, insertController, readController) {
        'use strict';

        var findRoutes = (function($routeProvider) {
            $routeProvider.when('/home', {
                templateUrl: '/home',
                controller: queryController,
                resolve: {
                    init: queryController.init
                }
            }).when('/databaseName', {
                templateUrl: '/display-default',
                controller: nameController,
                resolve: {
                    databaseName: nameController.databaseName,
                    allDbs: nameController.allDbs
                }
            }).when('/createDb', {
                templateUrl: '/display-default',
                controller: queryController,
                resolve: {
                    result: queryController.create
                }
            }).when('/deleteDb', {
                templateUrl: '/display-default',
                controller: queryController,
                resolve: {
                    result: queryController.delete
                }
            }).when('/insertNpcs', {
                templateUrl: '/display-default',
                controller: insertController,
                resolve: {
                    result: insertController.insertNpcsOneDoc
                }
            }).when('/readNpcs', {
                templateUrl: '/row-display-one-doc',
                controller: readController,
                resolve: {
                    result: readController.readOne,
                    init: readController.init
                }
            }).otherwise({
                redirectTo: '/home'
            });
        });

        return findRoutes;

    });

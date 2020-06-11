(function () {

    'use strict';

    // nome controller
    var controllerName = 'eventosController';

    // configuração do controller 
    angular.module('eventosApp')
        .controller(controllerName,
                ['$scope',
                 '$log',
                 '$location',
                 '$routeParams',
                 'SharePointDataContextService',
                  eventosController
                ]);

    // definição do controller
    function eventosController(
        $scope,
        $log,
        $location,
        $routeParams,
        SharePointDataContextService) {

        // inicializar controller
        init();

        // construtor 
        function init() { };
    };

}());
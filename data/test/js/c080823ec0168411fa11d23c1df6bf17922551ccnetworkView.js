(function () {
    "use strict";

    define(['./lib/canvas_service', './lib/toolbar_service', './lib/view_model', './lib/view_controller',
        'cytoscape'], function (canvasService, toolbarService, model, controller) {

        angular.module('networkView', []).
            service('toolbarService', toolbarService).
            service('canvasService', ['$http', '$q', '$rootScope', canvasService]).
            service('viewModel', model).
            controller('viewController', ['$scope', 'viewModel', '$routeParams', 'toolbarService', 'canvasService', 'networkService', controller]);

    });

}());
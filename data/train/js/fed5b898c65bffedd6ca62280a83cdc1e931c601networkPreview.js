(function () {
    "use strict";

    define(['./lib/preview_service', './lib/preview_model', './lib/preview_controller'],
        function (previewService, model, controller) {

        angular.module('networkPreview', []).
            service('previewService', ['$http', '$q', 'networkService', previewService]).
            service('previewModel', [model]).
            controller('previewController', ['$scope', 'previewModel', '$routeParams', 'filterService', 'previewService', 'settingsService', controller]);

    });

}());
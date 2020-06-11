(function () {
    "use strict";

    var def_requirements = ['angular',
        './libs/model', './libs/controller', './libs/route_config',
        './libs/form_check.service',
        './mods/homepage/libs/controller', './mods/homepage/mods/guest/libs/controller',
        './mods/homepage/mods/user/libs/controller', './mods/user_activate/libs/controller',
        './mods/interface/libs/controller',
        './mods/interface/libs/filters.service', './mods/interface/libs/navigate.service',
        './mods/interface/libs/network.service',
        './mods/interface/libs/network_attribute.service',
        './mods/interface/libs/network_group.service',
        './mods/interface/libs/inspector.service', './mods/interface/libs/panels.service',
        './mods/interface/libs/commander.service', './mods/interface/libs/canvas.service',
        './mods/interface/libs/settings.service', './mods/interface/libs/sessions.service',
        './mods/uploader/libs/service', 
        './mods/uploader/libs/directive', './mods/uploader/libs/submit_form.directive',
        'angular-route', 'angular-animate', 'jquery', 'dropzone'];

    define(def_requirements,
        function (angular, model, controller, routeConfig,
            formCheckService,
            homepageController, guestpageController,
            userpageController, activateController,
            interfaceController,
            filterService, navigateService,
            networkService,
            networkAttributeService, networkGroupService,
            inspectorService, panelsService,
            commanderService, canvasService,
            settingsService, sessionsService,
            uploaderService,
            autoclickDirective, submitformDirective) {
        
        angular.module('tea', ['ngRoute', 'ngAnimate']).
        	config(['$routeProvider', routeConfig]).

            service('formCheckService', [formCheckService]).

        	service('appModel', [model]).
        	controller('appController', ['$scope', 'appModel', controller]).

            controller('homepageController', [
                '$scope', 'appModel', '$http', '$timeout', '$rootScope',
                homepageController
            ]).
            controller('guestpageController', [
                '$scope', 'appModel', '$http', '$timeout', '$rootScope',
                'formCheckService',
                guestpageController
            ]).
            controller('userpageController', [
                '$scope', 'appModel', '$http', '$timeout', '$rootScope',
                'formCheckService',
                userpageController
            ]).
            controller('activateController', [
                '$scope', 'appModel', '$http', '$timeout',
                '$routeParams',
                activateController
            ]).
            
            service('networkAttributeService', [
                '$q', '$http', '$rootScope',
                networkAttributeService
            ]).
            service('convertGroupService', [networkGroupService]).
            service('mergeGroupService', [networkGroupService]).
            service('intersectGroupService', [networkGroupService]).
            service('subtractGroupService', [networkGroupService]).
            service('containsGroupService', [networkGroupService]).
            service('distancesGroupService', [networkGroupService]).
            service('filterService', [filterService]).
            service('navigateFilterService', [filterService]).
            service('navigateService', [
                '$q', '$http', 'navigateFilterService',
                navigateService
            ]).

            service('canvasService', [
                '$q', '$http', '$rootScope', 'filterService', 'navigateService',
                canvasService
            ]).
            service('commanderService', [
                '$q', '$http', '$timeout', '$rootScope',
                'mergeGroupService', 'intersectGroupService', 'subtractGroupService',
                'containsGroupService', 'distancesGroupService',
                commanderService
            ]).
            service('inspectorService', [inspectorService]).
            service('networkService', [
                '$q', '$http', '$rootScope',
                'convertGroupService', 'networkAttributeService',
                networkService
            ]).
            service('panelsService', ['$rootScope', panelsService]).
            service('settingsService', ['$q', '$http', '$rootScope', settingsService]).
            service('sessionsService', ['$q', '$http', '$rootScope', sessionsService]).
            service('uploaderService', ['$http', '$q', '$timeout', uploaderService]).
            controller('interfaceController', [
                '$q', '$scope', 'appModel', '$routeParams',
                'networkService', 'panelsService', 'inspectorService',
                'commanderService', 'canvasService', 'settingsService',
                'sessionsService', 'uploaderService',
                interfaceController
            ]).

            directive('uploaderAutoclick', [
                '$parse',
                function ($parse) { return { restrict: 'A', link: autoclickDirective }; }
            ]).
            directive('submitForm', [
                function () { return { restrict: 'A', link: submitformDirective }; }
            ])

    });

}());

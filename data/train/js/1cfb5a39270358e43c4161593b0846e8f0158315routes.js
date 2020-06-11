'use strict';
angular.module('d2Docs')
    .config(function ($routeProvider) {
        $routeProvider
            /**/
            .when('/examples', {
                templateUrl: 'examples.html',
                controller: 'sectionController',
                controllerAs: 'section'
            })
            /**/
            .when('/examples/Basic usage', {
                templateUrl: 'examples/Basic_usage.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/examples/How do i', {
                templateUrl: 'examples/How_do_i.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            /**/
            .when('/general', {
                templateUrl: 'general.html',
                controller: 'sectionController',
                controllerAs: 'section'
            })
            /**/
            .when('/general/Install', {
                templateUrl: 'general/Install.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            /**/
            .when('/d2', {
                templateUrl: 'd2.html',
                controller: 'sectionController',
                controllerAs: 'section'
            })
            /**/
            .when('/d2/d2', {
                templateUrl: 'd2.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            /**/
            .when('/i18n', {
                templateUrl: 'i18n.html',
                controller: 'sectionController',
                controllerAs: 'section'
            })
            /**/
            .when('/i18n/I18n', {
                templateUrl: 'i18n/I18n.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            /**/
            .when('/model', {
                templateUrl: 'model.html',
                controller: 'sectionController',
                controllerAs: 'section'
            })
            /**/
            .when('/model/Filter', {
                templateUrl: 'model/Filter.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/model/Model', {
                templateUrl: 'model/Model.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/model/ModelBase', {
                templateUrl: 'model/ModelBase.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/model/ModelCollection', {
                templateUrl: 'model/ModelCollection.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/model/ModelDefinition', {
                templateUrl: 'model/ModelDefinition.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/model/ModelDefinitions', {
                templateUrl: 'model/ModelDefinitions.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/model/ModelValidation', {
                templateUrl: 'model/ModelValidation.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            /**/
            .when('/pager', {
                templateUrl: 'pager.html',
                controller: 'sectionController',
                controllerAs: 'section'
            })
            /**/
            .when('/pager/Pager', {
                templateUrl: 'pager/Pager.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            /**/
            .when('/system', {
                templateUrl: 'system.html',
                controller: 'sectionController',
                controllerAs: 'section'
            })
            /**/
            .when('/system/System', {
                templateUrl: 'system/System.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/system/SystemConfiguration', {
                templateUrl: 'system/SystemConfiguration.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/system/SystemSettings', {
                templateUrl: 'system/SystemSettings.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            .when('/system/settingsKeyMapping', {
                templateUrl: 'system/settingsKeyMapping.json',
                controller: 'pageController',
                controllerAs: 'page'
            })
            /**/
            /**/
            ;
    });


'use strict';

angular.module('autopsApp')
    .config(function ($stateProvider, $urlRouterProvider) {
        $urlRouterProvider.when('/service', '/service/view');
        $stateProvider
            .state('service', {
                url: '/service',
                templateUrl: 'app/service/service.html',
                controller: 'ServiceCtrl',
                authenticate: true
            })
            .state('service.view', {
                url: '/view',
                templateUrl: 'app/service/service.view.html',
                controller: 'ServiceViewCtrl',
                authenticate: true
            });
    })
;
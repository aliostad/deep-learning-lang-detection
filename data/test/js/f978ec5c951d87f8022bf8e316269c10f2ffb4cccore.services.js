define([
    'angular',
    './settings-service',
    './products-service',
    './shopping-service',
    './auth-service',
    './pubsub-service',
    'restangular',
    'angularStorage'
], function (angular, settingsService, productsService, shoppingService, authService, pubsubService) {
    'use strict';

    var moduleName = 'southerncreations.core.services',
        module;

    module = angular.module(moduleName, [
            'restangular',
            'LocalStorageModule'
        ])
        .constant('STORAGE_KEYS', {
            'JWT': 'jwt',
            'SETTINGS': 'settings',
            'CART': 'cart'
        })
        .constant('API', {
            'BASE': '/api',
            'BASE_LOGIN': 'login',
            'BASE_SIGNIN': 'signin',
            'BASE_CATEGORIES': 'categories',
            'BASE_PRODUCTS': 'products',
            'BASE_SETTINGS': 'settings'
        })
        .config(['RestangularProvider', 'API', function (RestangularProvider, API) {
            RestangularProvider.setBaseUrl(API.BASE);
        }])
        .service(settingsService.name, settingsService.fn)
        .service(productsService.name, productsService.fn)
        .service(shoppingService.name, shoppingService.fn)
        .service(authService.name, authService.fn)
        .service(pubsubService.name, pubsubService.fn);

    return {
        name: moduleName,
        module: module
    };
});
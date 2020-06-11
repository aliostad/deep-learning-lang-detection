define([
    'angular',
    './controllers/products-controller',
    './controllers/productDetail-controller'
], function (angular, productsController, productDetailController) {
    'use strict';

    var moduleName = 'southerncreations.products',
        module;

    module = angular.module(moduleName, [])
        .controller(productsController.name, productsController.fn)
        .controller(productDetailController.name, productDetailController.fn);

    return {
        name: moduleName,
        module: module
    };
});
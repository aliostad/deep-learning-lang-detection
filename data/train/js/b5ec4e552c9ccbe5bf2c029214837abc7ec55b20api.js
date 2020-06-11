define(function (require) {

    var Navigation      = require('app/src/navigation'),
        // ApiList         = require('app/src/api_list'),
        // ApiRequest      = require('app/src/api_request'),
        // ApiResponse     = require('app/src/api_response'),

        symposia        = require('symposia'),

        config          = require('app/config');

    var sandbox = symposia.sandbox.create();

    symposia.router.addRoute(config.routes.api, function () {
        console.error("api");
        symposia.modules.create({
            'navigation': {
                creator: Navigation
            }
            // 'api_list': {
            //     creator: ApiList
            // },
            // 'api_request': {
            //     creator: ApiRequest
            // },
            // 'api_response': {
            //     creator: ApiResponse
            // }
        }).startAll();
    });
});

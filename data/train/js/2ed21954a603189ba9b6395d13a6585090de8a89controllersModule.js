define([
    'jquery',
    'ionic.angular',
    './dashController',
    './coursesController',
    './courseController'
], function(
    $,
    angular,
    dashController,
    coursesController,
    courseController) {

    var defaultConfig = {
        moduleName: 'starter.controllers'
    };

    return function(opts) {

        var config = $.extend({}, defaultConfig, opts);
        var app = angular.module(config.moduleName, []);

        dashController(app, config.dashControllerConfig || {});
        coursesController(app, config.coursesControllerConfig || {});
        courseController(app, config.courseControllerConfig || {});

        return app;

    }

});

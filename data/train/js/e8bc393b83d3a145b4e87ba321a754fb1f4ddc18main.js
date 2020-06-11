define('app/main',
    [
        'angular',
        'app/config',
        'app/controller/route',
        'app/controller/calendar',
        'app/controller/recipe',
        'app/directive/navigation'
    ], function(ng, config, RouteController, CalendarController, RecipeController, navigation) {
        'use strict';
        var app = ng.module('app', ['ngLocale', 'ngRoute']);
        app.config(config);
        app.directive('nav', navigation);
        app.controller('RouteController', RouteController);
        app.controller('CalendarController', CalendarController);
        app.controller('RecipeController', RecipeController);

    }
);
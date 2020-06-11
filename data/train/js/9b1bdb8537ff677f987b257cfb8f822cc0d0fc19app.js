var app = angular.module("tattooApp", ['ngRoute']);
var nav = new tattooNav();
var urlConfig = urlConfig();
app.config(function ($routeProvider) {
    var urlPrefix = window.tattooWeb.angularBaseUrl + 'partials/';

    for (var i = 0; i < nav.menuItems.length; i++) {
        $routeProvider.when(nav.menuItems[i].link, {
            controller: nav.menuItems[i].controller,
            templateUrl: urlPrefix + nav.menuItems[i].templateUrl
        });
    }

    for (var i = 0; i < nav.subNav.length; i++) {
        $routeProvider.when(nav.subNav[i].link, {
            controller: nav.subNav[i].controller,
            templateUrl: urlPrefix + nav.subNav[i].templateUrl
        });
    }

    $routeProvider.when(nav.errorNav.link, {
        controller: nav.errorNav.controller,
        templateUrl: urlPrefix + nav.errorNav.templateUrl
    });

    $routeProvider.otherwise({ redirectTo: nav.defaultNav });
});
selectedBus = null;
selectedStop = null;

var app = angular.module("myApp", ["ngRoute"]);

app.controller("busesController", busesController)
    .controller("busController", busController)
    .controller("stopController", stopController)
    .controller("dropdownController", dropdownController)
    .controller("errorController", errorController)
    .config(routeSetup)
    .directive("titleDirective", titleDirective)
    .directive("navDirective", navDirective)
    .service("busesService", busesService)
    .service("translationService", translationService);
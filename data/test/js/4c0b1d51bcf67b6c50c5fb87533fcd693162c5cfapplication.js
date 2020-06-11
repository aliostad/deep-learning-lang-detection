angular.module('pilka', ['ngSanitize', 'ajoslin.promise-tracker'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider.
           
            when("/", { templateUrl: 'content/miejsca.html', controller: ControllerLista }).
            when("/gramy", { templateUrl: 'content/gramy.html', controller: ControllerGramy }).
            when("/niegramy", { templateUrl: 'content/niegramy.html', controller: ControllerNieGramy }).
            when("/lista", { templateUrl: 'content/miejsca.html', controller: ControllerLista }).
            when("/osoba/:username", { templateUrl: 'content/osoby.html', controller: ControllerOsoby }).
            when("/sendok", { templateUrl: 'content/sendok.html', controller: ControllerConfirm }).
            when("/sendno", { templateUrl: 'content/sendno.html', controller: ControllerConfirm }).
            when("/startup", { templateUrl: 'content/miejsca.html', controller: ControllerLista }).
            when("/confirm", { templateUrl: 'content/confirm.html', controller: ControllerConfirm });
    }]);


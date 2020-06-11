ClubPadelApp.config(function ($routeProvider) {

    $routeProvider
            .when('/', {
                templateUrl: 'inicio.html',
                controller: 'inicioController'
            })
            .when('/verInstalaciones', {
                templateUrl: 'instalaciones.html',
                controller: 'instalacionesController'
            })
            .when('/reservar', {
                templateUrl: 'reservar.html',
                controller: 'reservarController'
            })
            .when('/galeria', {
                templateUrl: 'galeria.html',
                controller: 'galeriaController'
            })
            .when('/normativa', {
                templateUrl: 'normativa.html',
                controller: 'normativaController'
            })
            .when('/tarifas', {
                templateUrl: 'tarifas.html',
                controller: 'tarifasController'
            })
            .when('/contacto', {
                templateUrl: 'contacto.html',
                controller: 'contactoController'
            })
            .when('/registro', {
                templateUrl: 'registro.html',
                controller: 'registroController'
            })
            .when('/login', {
                templateUrl: 'login.html',
                controller: 'loginController'
            })
            .when('/logout', {
                templateUrl: 'login.html',
                controller: 'logoutController'
            })
            .otherwise({
                redirectTo: '/'
            });
});
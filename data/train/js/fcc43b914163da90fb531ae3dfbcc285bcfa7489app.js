(function(){
  
  var app = angular.module('aquila',
    [
      'mainController',
      'deviceController',
      'interactionController',
      'configuracionController',
      'aquilaFactorys',
      'ngRoute'
    ]
  );
  

  app.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/', {
        templateUrl: 'views/dispositivos/dispositivos.html',
        controller: 'DeviceController'
      }).
      when('/interacciones', {
        templateUrl: 'views/interacciones/interacciones.html',
        controller: 'InteractionController'
      }).
      when('/configuraciones', {
        templateUrl: 'views/configuracion/configuracion.html',
        controller: 'ConfiguracionController'
      }).
      otherwise({
        redirectTo: '/404error'
      });
  }]);

  


})();
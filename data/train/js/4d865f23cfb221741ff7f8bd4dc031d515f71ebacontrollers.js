define(function (require) {
   
  var angular = require('angular'), Controllers = angular.module('controllers', []);
   
  Controllers.controller('CuentaController', require('controllers/CuentaController'));

  Controllers.controller('EditorController', require('controllers/EditorController'));

  Controllers.controller('SuscripcionController', require('controllers/SuscripcionController'));
  
  Controllers.controller('RevistaController', require('controllers/RevistaController'));

  Controllers.controller('PerfilController', require('controllers/PerfilController'));

  Controllers.controller('NuevaController', require('controllers/NuevaController'));

  Controllers.controller('IniciarController', require('controllers/IniciarController'));

  return Controllers;
   
});
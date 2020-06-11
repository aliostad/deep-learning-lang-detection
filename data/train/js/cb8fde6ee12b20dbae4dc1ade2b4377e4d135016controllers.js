define(function (require) {
   
  var angular = require('angular'),
  Controllers = angular.module('controllers', []);
   
  Controllers.controller('ExpedientesController', require('controllers/ExpedientesController'));
  Controllers.controller('UsuariosController', require('controllers/UsuariosController'));
  Controllers.controller('ContactoController', require('controllers/ContactoController'));
  Controllers.controller('DocumentosController', require('controllers/DocumentosController'));
  Controllers.controller('Expediente_editarController', require('controllers/Expediente_editarController'));
  Controllers.controller('Contacto_editarController', require('controllers/Contacto_editarController'));
  Controllers.controller('Foto_editarController', require('controllers/Foto_editarController'));
  return Controllers;
   
});
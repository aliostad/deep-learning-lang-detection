UsuariosService = require('./usuarios_service.js');
EncuentrosService = require('./encuentros_service.js');
ServiciosService = require('./servicios_service.js');
FiestasService = require('./fiestas_service.js');

function PregoServices() {
    var __store = {};
    var __usuariosService = new UsuariosService(__store);
	var __encuentrosService = new EncuentrosService(__store, this);
	var __serviciosService = new ServiciosService(__store);
	var __fiestasService = new FiestasService(__store, this);

    this.setStore = function (store) {
		__store = store;
		__usuariosService.setStore(__store);
		__encuentrosService.setStore(__store);
		__serviciosService.setStore(__store);
		__fiestasService.setStore(__store);
    }

    this.rellenar = function () {
        __usuariosService.rellenar();
        __encuentrosService.rellenar();
        __serviciosService.rellenar();
		__fiestasService.rellenar();
    }

    this.rellenarDemo = function () {
        __usuariosService.rellenarDemo();
        __encuentrosService.rellenarDemo();
        __serviciosService.rellenarDemo();
		__fiestasService.rellenarDemo();
    }

    this.getUsuariosService = function () {
        return __usuariosService;
    }
	
    this.getEncuentrosService = function () {
        return __encuentrosService;
    }
    
    this.getServiciosService = function () {
        return __serviciosService;
    }
    
    this.getFiestasService = function () {
        return __fiestasService;
    }
}

module.exports = PregoServices;

var rutas_api_empresa = require('./api_empresa.js');
var rutas_api_cuenta = require('./api_cuenta.js');
var rutas_api_plandecuentas = require('./api_plandecuentas.js');
var rutas_api_ejercicio = require('./api_ejercicio.js');
var rutas_api_periodo = require('./api_periodo.js');
var rutas_api_asiento = require('./api_asiento.js');


module.exports = function (app) {
	rutas_api_empresa(app);
    rutas_api_cuenta(app);
    rutas_api_plandecuentas(app);
    rutas_api_ejercicio(app);
    rutas_api_periodo(app);
    rutas_api_asiento(app);
}

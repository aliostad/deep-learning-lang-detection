(function(){
'use strict';

var app = angular.module('liquidacionApp',[]),
    PanelBusquedaController = require('../controllers/liquidacion/panel_busqueda_controller.js'),
    LiquidacionController = require('../controllers/liquidacion/liquidacion_controller.js'),
    ProductoController = require('../controllers/liquidacion/producto_controller.js'),
    GuiaPropiaController = require('../controllers/liquidacion/guia_propia_controller.js'),
    GuiaLipigasController = require('../controllers/liquidacion/guia_lipigas_controller.js'),
    VoucherLipigasController = require('../controllers/liquidacion/voucher_lipigas_controller.js'),
    VoucherTransbankController = require('../controllers/liquidacion/voucher_transbank_controller.js'),
    ChequeController = require('../controllers/liquidacion/cheque_controller.js'),
    CuponPrepagoController = require('../controllers/liquidacion/cupon_prepago_controller.js'),
    OtroController = require('../controllers/liquidacion/otro_controller.js'),
    GarantiasController = require('../controllers/liquidacion/garantias_controller.js'),
    liquidacionService = require('../services/liquidacion_service.js'),
    formatoPeso = require('../filters/string_filters.js').formatoPeso,
    mantieneRestanteService = require('../services/mantiene_restante_service.js');

app.filter('formatoPeso', formatoPeso);
app.factory('liquidacionService', liquidacionService);
app.factory('mantieneRestanteService', mantieneRestanteService);
app.factory('calculaRestanteService', function(){
    return {
        calculaRestante: function(producto){
            if(typeof producto.llenos !== 'undefined'){
                producto.llenos = producto.llenos.replace(/\D+/g, '');
            }

            var aux = parseInt(producto.cantidad) - parseInt(producto.llenos);

            if(isNaN(aux) || aux < 0){
                aux = 0;
            }

            if(producto.cantidad < parseInt(producto.llenos)){
                producto.llenos = producto.cantidad;
            }

            producto.vacios = aux;
        }
    };
});

app.controller('PanelBusquedaController', ['$scope', 'liquidacionService', PanelBusquedaController]);
app.controller('LiquidacionController', ['$scope', 'liquidacionService', LiquidacionController]);
app.controller('ProductoController', ['$scope', 'calculaRestanteService', ProductoController]);
app.controller('GuiaPropiaController', ['$scope', 'liquidacionService','mantieneRestanteService', GuiaPropiaController]);
app.controller('GuiaLipigasController', ['$scope', 'liquidacionService','mantieneRestanteService', GuiaLipigasController]);
app.controller('VoucherLipigasController', ['$scope', VoucherLipigasController]);
app.controller('VoucherTransbankController', ['$scope', VoucherTransbankController]);
app.controller('ChequeController', ['$scope', ChequeController]);
app.controller('CuponPrepagoController', ['$scope', 'mantieneRestanteService', CuponPrepagoController]);
app.controller('OtroController', ['$scope', OtroController]);
app.controller('GarantiasController', ['$scope', 'liquidacionService', GarantiasController]);

})();

$('button[data-accion=abre_modal]').on('click', function(evt){
    $('#modal_' + $(this).data('modal')).modal('show');
});

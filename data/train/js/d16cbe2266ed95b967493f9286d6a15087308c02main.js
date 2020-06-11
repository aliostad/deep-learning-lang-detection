/**
 * Created by cacho on 24/10/13.
 */
'use strict';


var cntShow = 0;
var IndicadorEnabled = 1;
var showIndicador = function () {
    if (IndicadorEnabled == 1) {
        $("#veil").show();
        $("#prLoading").show();
        cntShow = cntShow + 1;
    }
    //console.log(cntShow);
}

var hideIndocador = function () {
    cntShow = cntShow - 1;
    //console.log(cntShow);
    if (cntShow <= 0) {
        cntShow = 0;
        $("#veil").hide();
        $("#prLoading").hide();
    }
}

var setIndicadorEnabled = function (valor) {
    IndicadorEnabled = valor;
}


showIndicador();


$(document).ready(function () {
    hideIndocador();
})

//Llamadas Ajax de jQuery

jQuery(document).ajaxStop(function () {
    hideIndocador();
});

jQuery(document).ajaxStart(function () {
    showIndicador();
});


jQuery.fn.center = function () {
    this.css("position","absolute");
    this.css("top", ( $(window).height() - this.height() ) / 2+$(window).scrollTop() + "px");
    this.css("left", ( $(window).width() - this.width() ) / 2+$(window).scrollLeft() + "px");
    return this;
}

$(document).ready(fadeInicio);

function fadeInicio(){
  $("#inicio").center();
  setTimeout(hideInicio, 2000);
}

function hideInicio(){
    $("#inicio").transition({
    animation  : 'scale',
    duration   : '2s',
    onComplete : showMenu
  });
}
///////////////////////////////////////////
function showMenu(){
    $("#sideBar").sidebar('toggle');
}
///////////////////////////////////////////
$("#botonMenu").click(showMenu);
///////////////////////////////////////////
$("#botonReportar").click(showModalReport);

function showModalReport(){
	$('#reportarModal').modal('show');
}
///////////////////////////////////////////
$("#botonLogin").click(showModalLogin);

function showModalLogin(){
	$('#loginModal').modal('show');
}
///////////////////////////////////////////
$("#botonHistoria").click(showModalHistoria);

function showModalHistoria(){
	$('#historiaModal').modal('show');
}
///////////////////////////////////////////
$("#botonMision").click(showModalMision);

function showModalMision(){
	$('#misionModal').modal('show');
}
///////////////////////////////////////////
$("#botonVision").click(showModalVision);

function showModalVision(){
	$('#visionModal').modal('show');
}
///////////////////////////////////////////
$("#botonBase").click(showModalBase);

function showModalBase(){
    $('#baseModal').modal('show');
}
///////////////////////////////////////////
$("#botonPorhora").click(showModalPorhora);

function showModalPorhora(){
    $('#porhoraModal').modal('show');
}
///////////////////////////////////////////

$("#botonSolicitar").click(showModalCuantos);
$("#botonSolicitar2").click(showModalCuantos);
$("#botonSolicitar3").click(showModalCuantos);
$("#botonSolicitar4").click(showModalCuantos);
$("#botonSolicitar5").click(showModalCuantos);

function showModalCuantos(){
    $('#cuantosModal').modal('show');
}

$("#botonSolicitar6").click(showModalCuantos2);
$("#botonSolicitar7").click(showModalCuantos2);
$("#botonSolicitar8").click(showModalCuantos2);
$("#botonSolicitar9").click(showModalCuantos2);
$("#botonSolicitar10").click(showModalCuantos2);

function showModalCuantos2(){
    $('#cuantosModal2').modal('show');
}

$("#botonCheck").click(showModalCheck);
$("#botonCheck2").click(showModalCheck);

function showModalCheck(){
    $('#checkModal').modal('show');
}
///////////////////////////////////////////
$("#botonUbicacion").click(showModalUbicacion);

function showModalUbicacion(){
    $('#ubicacionModal').modal('show');
}
///////////////////////////////////////////
$('.ui.video').video();
$('#videoCocina').video();
$('#videoSala').video();


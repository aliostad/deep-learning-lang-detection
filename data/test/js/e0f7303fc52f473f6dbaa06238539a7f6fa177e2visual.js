$(document).ready(function(){

	//Efeito da nav-bar:
	$("#nav-wrapper").hide();
    $(window).scroll(function(){
        if($(window).scrollTop() >  $(".nav-header").outerHeight()) {
        	$("#nav-wrapper").slideDown();
        } else {
        	$("#nav-wrapper").slideUp();
        }
    });

    //Limpar campo da pesquisa no topo:
    var topo = $("#topo-busca").val();
    $("#topo-busca").focus(function() {
    	$("#topo-busca").val("");
    });
    $("#topo-busca").focusout(function() {
    	$("#topo-busca").val(topo);
    });

    //Limpar campo da pesquisa no topo:
    var nav = $("#nav-busca").val();
    $("#nav-busca").focus(function() {
    	$("#nav-busca").val("");
    });
    $("#nav-busca").focusout(function() {
    	$("#nav-busca").val(nav);
    });
});

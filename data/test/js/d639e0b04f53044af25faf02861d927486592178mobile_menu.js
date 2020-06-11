// JavaScript Document
$(document).ready(function(){
	var n = true;
    $("#expand").click(function(){
		if (n) {
			n = false;
			$( "#menu0" ).addClass( "navToggle" );
			$( "#menu1" ).addClass( "navToggle" );
			$( "#menu2" ).addClass( "navToggle" );
			$( "#menu3" ).addClass( "navToggle" );
			$( "#menu4" ).addClass( "navToggle" );
			$( "#menu5" ).addClass( "navToggle" );
			$( "#menu6" ).addClass( "navToggle" );
			$( "#menu7" ).addClass( "navToggle" );
			$( "#menu8" ).addClass( "navToggle" );
		} else {
			n = true;
			$( "#menu0" ).removeClass( "navToggle" );
			$( "#menu1" ).removeClass( "navToggle" );
			$( "#menu2" ).removeClass( "navToggle" );
			$( "#menu3" ).removeClass( "navToggle" );
			$( "#menu4" ).removeClass( "navToggle" );
			$( "#menu5" ).removeClass( "navToggle" );
			$( "#menu6" ).removeClass( "navToggle" );
			$( "#menu7" ).removeClass( "navToggle" );
			$( "#menu8" ).removeClass( "navToggle" );
		}
    });
});
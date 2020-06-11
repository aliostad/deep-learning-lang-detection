$(document).ready(function(){
	$("ul#nav li").hover(function(){
		$(this).addClass("hover");
	}, function(){
		$(this).removeClass("hover");
	});
	
	$(".nav_button").click(function(){
		$(".nav_x, #nav").show();
		$(".nav_button").hide();
	});
	$(".nav_x").click(function(){
		$(".nav_x, #nav").hide();
		$(".nav_button").show();
	});

	deviceDetect();
}); // END DOC.READY

window.onresize = deviceDetect;

// DETERMINE DEVICE
	function deviceDetect(){
	var viewportwidth = window.innerWidth;
	var viewportheight = window.innerHeight;
	if ((viewportwidth) < 768) { mobileJS();}
	else { desktopTabletJS(); }
	}

// :::::::::::::::::::::::::::::::::::::
// :: DESKTOP ::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::::::::

function mobileJS(){
	$(".nav_x, #nav").hide();
	$(".nav_button").show();
}

function desktopTabletJS(){
	$(".nav_x, .nav_button").hide();
	$("#nav").show();
}
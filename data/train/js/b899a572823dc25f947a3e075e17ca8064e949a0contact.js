$(document).ready( function() {	
	$("#bv_contact_map").css("innerHTML","MAP DOWNLOADING...");
	$("#bv_nav_link2").css("border-bottom","solid");
	$("#bv_nav_link2").css("color","#E91E63");
	
	$("#bv_nav_link1").css("color","#FFFFFF");
	$("#bv_nav_link1").css("border-bottom","solid");
	
	$("#bv_nav_link2").mouseover(function(){
		$("#bv_nav_link2").css("color","#000000");
	});
	
	$("#bv_nav_link2").mouseout(function(){
		$("#bv_nav_link2").css("color","#E91E63");
	});
	
	$("#bv_nav_link1").mouseover(function(){
		$("#bv_nav_link1").css("color","#000000");
	});
	
	$("#bv_nav_link1").mouseout(function(){
		$("#bv_nav_link1").css("color","#FFFFFF");
	});
});



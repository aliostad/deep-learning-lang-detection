$(document).ready(function(){
	var windowWidth = $(window).width();
	if(windowWidth < 500){
		$("#navToggle").css("display","inline-block");
		$("nav").hide();
		$(".breadcrumbs").hide();
	}

	$("#navToggle").click(function() {
		$("nav").slideToggle(300);
	});

	$(window).resize( function(){
		var windowWidth = $(window).width();
		if(windowWidth > 500){
			$("#navToggle").css("display", "none");
			$("nav").show();
			$(".breadcrumbs").show();
		}else{
			$("#navToggle").css("display","inline-block");
			$("nav").hide();
			$(".breadcrumbs").hide();
		}
	});
});


$( document ).ready(function() {
	
	$(".nav-oppener").on("click",function(){
		$(".hamb").css("opacity","0");
		$(this).addClass("nav-oppener--active");
		$(this).removeClass("nav-oppener--non-active");
		$(".nav").addClass("nav--active");
		$(".cross").addClass("cross--active");
	});
	

	$(".nav-closer").on("click",function(){
		$(".cross").removeClass("cross--active");
		$(".nav").addClass("nav--non-active");
		$(".nav").removeClass("nav--active");

		setTimeout(function() {
			$(".nav-oppener").addClass("nav-oppener--non-active");
			$(".nav-oppener").removeClass("nav-oppener--active");
			$(".nav").removeClass("nav--non-active");
			
 		}, 400);

 		setTimeout(function() {
			$(".hamb").css("opacity","1");
 		}, 700);

 		

		
	});

});
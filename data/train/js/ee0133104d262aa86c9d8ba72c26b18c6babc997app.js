$( document ).ready(function() {
	

	// $(".nav-oppener").on("click",function(){
	// 	$(".nav").addClass("nav--active");
	// 	$(".page--1").addClass("page--active");
	// 	$(this).addClass("nav-oppener--active");
	// });


	$(".nav-oppener").on("click",function() {
		if ( !$(".nav").hasClass("nav--active") ) {

			$(".nav-oppener").addClass("nav-oppener--active");
			$(".nav").addClass("nav--active");
			$(".page--1").addClass("page--active");
			

			$(".nav").removeClass("nav--non-active");
			$(".page--1").removeClass("page--non-active");
			$(this).removeClass("nav-oppener--non-active");
		}

		else {
			$(".nav").addClass("nav--non-active");
			$(".page--1").addClass("page--non-active");
			$(".nav-oppener").addClass("nav-oppener--non-active");

			$(".nav").removeClass("nav--active");
			$(".page--1").removeClass("page--active");
			$(this).removeClass("nav-oppener--active");
			

		}
	});

	// $(".page--1").on("click",function() {
	// 	$(".nav").removeClass("nav--active");
	// 	$(".page--1").removeClass("page--active");
	// 	$(this).removeClass("nav-oppener--active");
	// });






});
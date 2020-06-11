function adjustNav () {
	if ( $(window).width() < 1024 ) {
		$(".mobile-nav").css("display", "block");
		$("nav ul").css("display", "none").removeClass("desktop").addClass("mobile");
	} else {
		$(".mobile-nav").css("display", "none");
		$("nav ul").css("display", "block").removeClass("mobile").addClass("desktop");
	}
	$(".core").removeClass("nav-visible");
}

// Adjust nav appearance initially
adjustNav();

// Adjust nav appearance every time window is resized
$(window).resize(adjustNav);

// Toggle menu visibility in mobile mode
$(".mobile-nav").click(function () {
	$("nav ul").toggle();
	$(".core").toggleClass("nav-visible");
});
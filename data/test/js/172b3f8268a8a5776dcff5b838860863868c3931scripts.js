/* // JAVASCRIPT FOR SUBMENU \\ */

/* NON-DROPDOWN i.e. HOME */
$("#nav_link_home").click(function() {
	$(".show").removeClass("show");
	$("#nav_main").addClass("corner_bottom_rounded");
	$(".nav_link_active").removeClass("nav_link_active");
	$("#nav_link_home").addClass("corner_bottom_left_rounded");
});

/* BLOG */
$("#nav_link_blog").click(function() {
	if ( $(".nav_link_blog_sub").hasClass('show') ) {
		$(".show").removeClass("show");
		$("#nav_main").addClass("corner_bottom_rounded");
		$(".nav_link_active").removeClass("nav_link_active");
		$("#nav_link_home").addClass("corner_bottom_left_rounded");
	} else {
		$(".show").removeClass("show");
		$("#nav_main").removeClass("corner_bottom_rounded");
		$(".nav_link_active").removeClass("nav_link_active");
		$("#nav_link_home").removeClass("corner_bottom_left_rounded");

		$("#nav_expandable").addClass("show");
	    $(".nav_link_blog_sub").addClass("show");
		$("#nav_link_blog").addClass("nav_link_active");
	}
});

/* PORTFOLIO */
$("#nav_link_portfolio").click(function() {
	if ( $(".nav_link_portfolio_sub").hasClass('show') ) {
		$(".show").removeClass("show");
		$("#nav_main").addClass("corner_bottom_rounded");
		$(".nav_link_active").removeClass("nav_link_active");
		$("#nav_link_home").addClass("corner_bottom_left_rounded");
	} else {
		$(".show").removeClass("show");
		$("#nav_main").removeClass("corner_bottom_rounded");
		$(".nav_link_active").removeClass("nav_link_active");
		$("#nav_link_home").removeClass("corner_bottom_left_rounded");

		$("#nav_expandable").addClass("show");
	    $(".nav_link_portfolio_sub").addClass("show");
	    $("#nav_link_portfolio").addClass("nav_link_active");
	}
});

/* TUTORIALS */
$("#nav_link_tutorials").click(function() {
	if ( $(".nav_link_tutorials_sub").hasClass('show') ) {
		$(".show").removeClass("show");
		$("#nav_main").addClass("corner_bottom_rounded");
		$(".nav_link_active").removeClass("nav_link_active");
		$("#nav_link_home").addClass("corner_bottom_left_rounded");
	} else {
		$(".show").removeClass("show");
		$("#nav_main").removeClass("corner_bottom_rounded");
		$(".nav_link_active").removeClass("nav_link_active");
		$("#nav_link_home").removeClass("corner_bottom_left_rounded");

		$("#nav_expandable").addClass("show");
	    $(".nav_link_tutorials_sub").addClass("show");
	    $("#nav_link_tutorials").addClass("nav_link_active");
	}
});

/* NEWS */
$("#nav_link_news").click(function() {
	if ( $(".nav_link_news_sub").hasClass('show') ) {
		$(".show").removeClass("show");
		$("#nav_main").addClass("corner_bottom_rounded");
		$(".nav_link_active").removeClass("nav_link_active");
		$("#nav_link_home").addClass("corner_bottom_left_rounded");
	} else {
		$(".show").removeClass("show");
		$("#nav_main").removeClass("corner_bottom_rounded");
		$(".nav_link_active").removeClass("nav_link_active");
		$("#nav_link_home").removeClass("corner_bottom_left_rounded");

		$("#nav_expandable").addClass("show");
	    $(".nav_link_news_sub").addClass("show");
	    $("#nav_link_news").addClass("nav_link_active");
	}
});
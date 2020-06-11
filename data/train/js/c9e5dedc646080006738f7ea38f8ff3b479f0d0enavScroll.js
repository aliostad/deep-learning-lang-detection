$(document).ready(function () {
	var navbar_container = $("#navbar-container")
	var nav_container = $("#nav-container");
	var nav = $("#nav");
	var scroll_test = $(".category-header").height() - 150;
	$(window).on('scroll', function () {
		if(window.pageYOffset > scroll_test){
			if(nav_container.hasClass("nav-transparent")) {
				navbar_container.removeClass("navbar-transparent").addClass("navbar-default");
				nav_container.removeClass("nav-transparent").addClass("navbar-default");
				nav.removeClass("nav-transparent").addClass("nav");
			}
		} else {
			if(!nav_container.hasClass("nav-default")) {
				navbar_container.removeClass("navbar-default").addClass("navbar-transparent");
				nav_container.removeClass("navbar-default").addClass("nav-transparent");
				nav.removeClass("nav").addClass("nav-transparent");
			}
		}
	});
});
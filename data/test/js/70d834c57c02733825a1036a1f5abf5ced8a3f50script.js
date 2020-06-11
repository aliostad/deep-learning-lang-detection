/**
 * Ready
 */
$(document).ready(function() { 
	$("#nav-button").bind("click", nav_open);
	$("#nav").bind("mouseleave", nav_timer);
});

/**
 * Navigation drop down
 */
var nav_timeout = 500;
var nav_closetimer = 0;
var nav_ddmenuitem = 0;
var nav_buttonlink = 0;

function nav_open() {
	nav_canceltimer();
	nav_close();
	nav_ddmenuitem = $("#nav").css("visibility", "visible").css("display", "block");
	nav_buttonlink = $("#nav-span").addClass("navactive");
}

function nav_close() {
	if (nav_ddmenuitem) {
		nav_ddmenuitem.css("visibility", "hidden").css("display", "none");
		nav_buttonlink.removeClass("navactive");
	}
}

function nav_timer() {
	nav_closetimer = window.setTimeout(nav_close, nav_timeout);
}

function nav_canceltimer() {
	if (nav_closetimer) {
		window.clearTimeout(nav_closetimer);
		nav_closetimer = null;
	}
}

/**
 * Hijack the in-page article scrolling
 */
$("a[rel='footnote']").click(function() {
	var h = $(this).attr("href");
	var i = h.substr(h.indexOf("#")+1);
	var p = $("#"+i).offset();
	var n = p.top - 90;
	$(window).scrollTop(n);
	// color fade indicator $("#"+i+" a").animate( { backgroundColor: "#EFE4C2" }, 1000).delay(3000).animate( { backgroundColor: "none" }, 1000);
	return false;
});
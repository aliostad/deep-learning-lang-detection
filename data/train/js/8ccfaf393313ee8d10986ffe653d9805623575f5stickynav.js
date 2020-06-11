window.onscroll = function() {
	var nav = document.getElementsByTagName("nav")[0];
	var slider = document.getElementById("sliderContainer");
	var currentNavHeight = nav.offsetHeight;
	var navOffset = document.getElementsByTagName("header")[0].offsetHeight;
	var scrollBarPosition = window.pageYOffset || document.body.scrollTop;
	if (scrollBarPosition >= navOffset) {
		nav.classList.add("fixedNav");
		slider.style["margin-top"] = currentNavHeight + "px";
	}
	if (scrollBarPosition <= navOffset && nav.classList.contains("fixedNav")) {
		nav.classList.remove("fixedNav");
		slider.style["margin-top"] = "0px";
	}
}
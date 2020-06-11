/* ////////// NAV SCRIPTS ////////// */

function slideIn(pixelsPerMs, speedInMs) {
	var nav = document.getElementById("nav-container");
	var navPos = getStyleIntPxValue(nav, "right");
	nav.style.right = navPos + "px";
	var intervalId = setInterval(function() {
		if (navPos < 0) {
			navPos += pixelsPerMs;
			nav.style.right = navPos + "px";
		}
		else {
			clearInterval(intervalId);
			console.log("slideIn interval cleared");
		}
	}, speedInMs);
	disableScrollModule.disableScroll();
}

function slideOut(pixelsPerMs, speedInMs) {
	var nav = document.getElementById("nav-container");
	var navPos = getStyleIntPxValue(nav, "right");
	nav.style.right = navPos + "px";
	var intervalId = setInterval(function() {
		if (navPos > -(nav.clientWidth)) {
			navPos -= pixelsPerMs;
			nav.style.right = navPos + "px";
		}
		else {
			clearInterval(intervalId);
			console.log("slideOut interval cleared");
		}
	}, speedInMs);
	disableScrollModule.enableScroll();
}

// function to slide menu out
function toggleNavSlide() {
	var nav = document.getElementById("nav-container");

	// if nav is not out, slide it in
	if (window.getComputedStyle(nav).getPropertyValue("right") == "-300px") {
		console.log("run slideIn");
		slideIn(15, 15);
		//document.getElementById("nav-container").style.right = "0";
	}
	// if nav is out, slide it away
	else {
		console.log("run slideOut");
		slideOut(15, 15);
		//document.getElementById("nav-container").style.right = "-300px";
	}
}

// on nav button click, slide out menu
document.getElementById("nav-button").addEventListener("click", function() {
	toggleNavSlide();
});
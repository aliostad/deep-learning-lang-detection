window.onload = function() {
	mobileNavBtn = document.getElementById("backBtn");
	nav = document.getElementsByTagName("nav");
	
	mobileNavBtn.onclick = function() {
		if (mobileNavBtn.style.display = "block") {
			mobileNavBtn.style.display = "none";
			nav.style.position = "fixed";
			nav.style.top = "90%";
			nav.style.left = "88%";
			nav.style.width = "25px";
			nav.style.height = "10%";
			nav.style.padding = ".5%";
			nav.style.backgroundSize = "auto 100%";
			nav.style.backgroundPosition = "top left";
		}
	};
}
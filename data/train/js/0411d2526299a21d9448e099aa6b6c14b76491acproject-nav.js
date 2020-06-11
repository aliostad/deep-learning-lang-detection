
function generateNav(){
	var navContainer = document.createElement("div");
	navContainer.className = "nav-container";
	var nav = document.createElement("nav");
	navContainer.appendChild(nav);

	nav.innerHTML = '<a class="nav-link" href="only-html5-video.html">OnlyHTML5Video</a> \
	<a class="nav-link" href="html5-games.html">HTML5 Games</a> \
	';

	var bodyEl = document.querySelector("body");
	bodyEl.insertBefore(navContainer, bodyEl.firstChild);
};


document.addEventListener('DOMContentLoaded', generateNav, false);
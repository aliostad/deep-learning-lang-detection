// JavaScript Document

navButton_over = function() {
	this.style.backgroundImage = 
		"url(img/NavButton" + this.navIndex + "_over.jpg)";
};

navButton_out = function() {
	this.style.backgroundImage = 
		"url(img/NavButton" + this.navIndex + "_norm.jpg)";
};

navButton_down = function() {
	this.style.backgroundImage = 
		"url(img/NavButton" + this.navIndex + "_down.jpg)";
	window.location.href = this.navUrl;
};

navButton_up = function() {
	this.style.backgroundImage = 
		"url(img/NavButton" + this.navIndex + "_over.jpg)";
};

navButton_init = function(navIndex, navUrl){
	
	var navButton = document.getElementById("navButton" + navIndex);
	
	navButton.onmouseover = navButton_over;
	navButton.onmouseout = navButton_out;
	navButton.onmousedown = navButton_down;
	navButton.onmouseup = navButton_up;

	navButton.navIndex = navIndex;
	navButton.navUrl = navUrl;
};

// init the app

ihf_load = function() {

	navButton_init(0, "about-us.html");
	navButton_init(1, "education.html");
	navButton_init(2, "projects.html");
	navButton_init(3, "events.html");
	navButton_init(4, "volunteer.html");
	navButton_init(5, "donate.html");
};

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-36374076-1']);
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

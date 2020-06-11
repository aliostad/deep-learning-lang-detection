(function() {

	// Mobiele navigatie
	var mobNav = document.getElementById("mobNav");
	var mobNavH = new Hammer(mobNav);

	var nav = document.getElementById("nav");

	var navAbout = document.getElementById("navAbout");
	var navAboutH = new Hammer(navAbout);

	var navMovies = document.getElementById("navMovies");
	var navMoviesH = new Hammer(navMovies);

	mobNavH.on("tap click press", function() {
		for(i = 0; i < mobNav.children.length; i++) {
			mobNav.children[i].classList.toggle("active");
		}

		nav.classList.toggle("active");
	});

	navAboutH.on("tap click press", function() {
		nav.classList.remove("active");
		mobNav.children[1].classList.remove("active");
		mobNav.children[0].classList.add("active");
		window.location.href = navAbout.href;
	});

	navMoviesH.on("tap click press", function() {
		nav.classList.remove("active");
		mobNav.children[1].classList.remove("active");
		mobNav.children[0].classList.add("active");
		window.location.href = navMovies.href;
	});

})();

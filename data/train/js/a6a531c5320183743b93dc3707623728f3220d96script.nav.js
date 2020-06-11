app.nav = {
	SET: {
		parent: null,
		nav: null
	},
	init: function() {
		// app.nav.SET.target = $("#wrapper > section:first");
		// app.nav.SET.nav = $("#nav > div");
		// app.nav.setParentHeight();
		// $(window).resize(app.nav.setParentHeight);

		$("#hamberger a").click(app.nav.toggleNav);
	},
	setParentHeight: function() {
		var h =  app.nav.SET.nav.outerHeight();
		if (h < 200){
			app.nav.SET.target.css("margin-top",h);
		}
	},
	toggleNav: function(){
		$("#nav > div").toggleClass("open");
		$(this).toggleClass("open");
	}
};
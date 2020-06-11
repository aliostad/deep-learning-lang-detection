$(document).ready(function() {

	var mainNav = "#nav_pri";
	var verticalNav = ".navi_vert";
	var horizontalNav = ".navi_hor";
	var orientation = "vertical";
	$(horizontalNav).hide();
	$(verticalNav).hide();

    if (orientation === "vertical") {
	    $(".navi").click(
			function (e) {
				e.preventDefault();
				var navContent = $(mainNav).html();
				$(verticalNav).html(navContent);
				$(verticalNav).slideToggle(300);
			});
	}

	if (orientation === "horizontal") {
		$(".navi").click(
			function (e) {
			e.preventDefault();
			var navContent = $(mainNav).html();
			$(horizontalNav).html(navContent);
		});
	}
});
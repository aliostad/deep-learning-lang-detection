<<<<<<< HEAD

$(document).ready(function() {
	$("#nav-mobile-icon").on("click", function() {
		$("#nav-content").toggleClass("active");
	});

	$("#nav-content a").on("click", function() {
		$("#nav-content a").removeClass("active");
		$(this).addClass("active");
	});

	$("#nav-logo").on("click", function() {
		$("#nav-content a").removeClass("active");
	});
});

=======

$(document).ready(function() {
	$("#nav-mobile-icon").on("click", function() {
		$("#nav-content").toggleClass("active");
	});

	$("#nav-content a").on("click", function() {
		$("#nav-content a").removeClass("active");
		$(this).addClass("active");
	});

	$("#nav-logo").on("click", function() {
		$("#nav-content a").removeClass("active");
	});
});

>>>>>>> 8cd87617556057032e194a56c33637cd1a304c4c

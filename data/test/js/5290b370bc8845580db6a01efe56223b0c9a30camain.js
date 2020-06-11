$(window).load(function() {
	$(".section").hide();
	$("#about_me").show();


	$("#l_about_me").click(function() {
		$(".section").hide();
		$("#about_me").show();
	});

	$("#l_skills").click(function() {
		$(".section").hide();
		$("#skills").show();
		$("#fb_like_button").show();
	});
	$("#l_contact").click(function() {
		$(".section").hide();
		$("#contact").show();
		$("#fb_like_button").show();
	});
	$("#l_gallery").click(function() {
		$(".section").hide();
		$("#gallery").show();
		$("#fb_like_button").show();
		$(".session").hide();
		$("#first_pro").show();

	});
	$("#l_life").click(function() {
		$(".section").hide();
		$("#life").show();
		$("#fb_like_button").show();
	});

   $("#firstpro").click(function() {
		$(".session").hide();
		$("#first_pro").show();
		$("#fb_like_button").show();
	});


   $("#seconpro").click(function() {
		$(".session").hide();
		$("#secon_pro").show();
		$("#fb_like_button").show();
	});
   $("#thirdpro").click(function() {
		$(".session").hide();
		$("#third_pro").show();
		$("#fb_like_button").show();
	});
	
});




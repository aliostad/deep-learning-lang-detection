$(document).ready(function() {
	
	/*$("div#show-1").click(
	  function () {
		$("div#nav-1").stop(true, true).slideToggle();
		$("div#show-1 div.z-nav").toggleClass("active");
	  }
	);
	
	$("div#show-1").hover(
		function() {
			$("div#show-1").closest("div.showAllButton").addClass("orange");
			$("div#show-1 div.z-nav").addClass("orange");
		},
		
		function() {
			$("div#show-1").closest("div.showAllButton").removeClass("orange");
			$("div#show-1 div.z-nav").removeClass("orange");
		}
	);
	
	$("div#show-2").click(
	  function () {
		$("div#nav-2").stop(true, true).slideToggle();
		$("div#show-2 div.z-nav").toggleClass("active");
	  }
	);
	
	$("div#show-2").hover(
		function() {
			$("div#show-2").closest("div.showAllButton").addClass("orange");
			$("div#show-2 div.z-nav").addClass("orange");
		},
		
		function() {
			$("div#show-2").closest("div.showAllButton").removeClass("orange");
			$("div#show-2 div.z-nav").removeClass("orange");
		}
	);
	
	$("div#show-3").click(
	  function () {
		$("div#nav-3").stop(true, true).slideToggle();
		$("div#show-3 div.z-nav").toggleClass("active");
	  }
	);
	
	$("div#show-3").hover(
		function() {
			$("div#show-3").closest("div.showAllButton").addClass("orange");
			$("div#show-3 div.z-nav").addClass("orange");
		},
		
		function() {
			$("div#show-3").closest("div.showAllButton").removeClass("orange");
			$("div#show-3 div.z-nav").removeClass("orange");
		}
	);
	
	$("div#show-4").click(
	  function () {
		$("div#nav-4").stop(true, true).slideToggle();
		$("div#show-4 div.z-nav").toggleClass("active");
	  }
	);
	
	$("div#show-4").hover(
		function() {
			$("div#show-4").closest("div.showAllButton").addClass("orange");
			$("div#show-4 div.z-nav").addClass("orange");
		},
		
		function() {
			$("div#show-4").closest("div.showAllButton").removeClass("orange");
			$("div#show-4 div.z-nav").removeClass("orange");
		}
	);
	
	$("div#show-5").click(
	  function () {
		$("div#nav-5").stop(true, true).slideToggle();
		$("div#show-5 div.z-nav").toggleClass("active");
	  }
	);
	
	$("div#show-5").hover(
		function() {
			$("div#show-5").closest("div.showAllButton").addClass("orange");
			$("div#show-5 div.z-nav").addClass("orange");
		},
		
		function() {
			$("div#show-5").closest("div.showAllButton").removeClass("orange");
			$("div#show-5 div.z-nav").removeClass("orange");
		}
	);
	
	$("div#show-6").click(
	  function () {
		$("div#nav-6").stop(true, true).slideToggle();
		$("div#show-6 div.z-nav").toggleClass("active");
	  }
	);
	
	$("div#show-6").hover(
		function() {
			$("div#show-6").closest("div.showAllButton").addClass("orange");
			$("div#show-6 div.z-nav").addClass("orange");
		},
		
		function() {
			$("div#show-6").closest("div.showAllButton").removeClass("orange");
			$("div#show-6 div.z-nav").removeClass("orange");
		}
	);
	
	$("div#show-7").click(
	  function () {
		$("div#nav-7").stop(true, true).slideToggle();
		$("div#show-7 div.z-nav").toggleClass("active");
	  }
	);
	
	$("div#show-7").hover(
		function() {
			$("div#show-7").closest("div.showAllButton").addClass("orange");
			$("div#show-7 div.z-nav").addClass("orange");
		},
		
		function() {
			$("div#show-7").closest("div.showAllButton").removeClass("orange");
			$("div#show-7 div.z-nav").removeClass("orange");
		}
	);
	
	$("div#show-8").click(
	  function () {
		$("div#nav-8").stop(true, true).slideToggle();
		$("div#show-8 div.z-nav").toggleClass("active");
	  }
	);
	
	$("div#show-8").hover(
		function() {
			$("div#show-8").closest("div.showAllButton").addClass("orange");
			$("div#show-8 div.z-nav").addClass("orange");
		},
		
		function() {
			$("div#show-8").closest("div.showAllButton").removeClass("orange");
			$("div#show-8 div.z-nav").removeClass("orange");
		}
	);
	
	$("div#show-9").click(
	  function () {
		$("div#nav-9").stop(true, true).slideToggle();
		$("div#show-9 div.z-nav").toggleClass("active");
	  }
	);
	
	$("div#show-9").hover(
		function() {
			$("div#show-9").closest("div.showAllButton").addClass("orange");
			$("div#show-9 div.z-nav").addClass("orange");
		},
		
		function() {
			$("div#show-9").closest("div.showAllButton").removeClass("orange");
			$("div#show-9 div.z-nav").removeClass("orange");
		}
	); */
	
	var windowWidth = $(window).width();
	//$('#topics').width(windowWidth);			
			
	/*$(window).resize( function () {
		$('#topics').width( $(window).width() );
	} );*/
	
	$(window).scroll( function() {
		var offset = $(window).scrollTop();

		if(offset > 100) {
			$('#topics #rLogo').fadeIn('slow');
		}
		if(offset < 100) {
			$('#topics #rLogo').fadeOut('slow');
		}
	});
			
	
	$("div.blogs div.blog-area:last").css("border-bottom", "none");
	$("div.blogs div.blog-area:last").css("padding-bottom", "0px");
	$("div.blogs div.blog-area:last").css("margin-bottom", "0px");
	
	$("div.text-stories div:last").css("border-bottom", "none");
	$("div.text-stories div:last").css("margin-bottom", "0px");
	$("div.text-stories div:last").css("padding-bottom", "0px");

});
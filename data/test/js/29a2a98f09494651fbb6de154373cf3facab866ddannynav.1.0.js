jQuery.noConflict();
(function ($) {
	$(function () {
		$("#danny-nav-toggle").click(function () {
			if ($('body').hasClass('has-danny-nav')) {
				$("body").removeClass('has-danny-nav');
				$('.danny-nav').removeClass("in");
			}
			else {
				$("body").addClass('has-danny-nav');
				$('.danny-nav').addClass("in");
			}
		});


		$(".danny-nav .nav-dropdown").hover(function () {
			if (!$('body').hasClass('has-danny-nav')) {
				$(this).children("ul").fadeIn();
			}
		}, function () {
			if (!$('body').hasClass('has-danny-nav')) {
				$(this).children("ul").fadeOut();
			}
		});

		$(".danny-nav .nav-dropdown").click(function () {
			if ($('body').hasClass('has-danny-nav')) {
			    $(this).children("ul").toggle();
			    event.stopPropagation();//阻止事件冒泡
			}

		});

		$(window).resize(function () {
		    if($(window).width()>960)
		    {
		        $("body").removeClass('has-danny-nav');
		        $('.danny-nav').removeClass("in");
		        $("#danny-nav-toggle").hide();
		    }
		    else
		    {
		        $("#danny-nav-toggle").fadeIn();
		    }
		 
		});





	


	});



	function doubleCheck()
	{
	    if ($(window).width() > 768) {
	        if ($('.danny-nav .container').width() < ($('.nav-content').width() + $('.nav-logo').width() + 20)) {
	            $('.danny-nav').addClass("double");
	        }
	    }
	}

	
})(jQuery);
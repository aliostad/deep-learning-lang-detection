

   $(document).ready(function(){
   	$('nav').addClass('hide');
	   $(window).bind('scroll', function() {
	   var navHeight = $( window ).height() - 50;

			 if ($(window).scrollTop() > navHeight) {
				 $('nav').addClass('fixed');
				 $('nav').removeClass('hide');
			 }
			 else {
				 $('nav').removeClass('fixed');
				 $('nav').addClass('wow hide');
			 }

		});
	$('.modal-trigger').leanModal();
	$('.button-collapse').sideNav();
    $('.parallax').parallax();
    $('.materialboxed').materialbox();
	});


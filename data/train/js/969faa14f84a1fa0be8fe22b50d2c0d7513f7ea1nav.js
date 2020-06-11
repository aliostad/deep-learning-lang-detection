
jQuery("document").ready(function($){
	
    $('.logo-nav').hide();
    var nav = $('.header');
    
    $(window).scroll(function () {
    	
        if ($(this).scrollTop() > 310) {
            nav.addClass("f-nav");
            nav.css('height', '124px');
            nav.css('top', '0px');
			/*$('.header').animate({
				//opacity: 0.25,
				top: "+=50",
				height: "toggle"
				}, 1000, function() {
				// Animation complete.
			});*/
             //$('.logo-nav').show();
        } else {
            nav.removeClass("f-nav");
             //$('.logo-nav').hide();
             nav.css('height', '300px');
        }
    });
 
});
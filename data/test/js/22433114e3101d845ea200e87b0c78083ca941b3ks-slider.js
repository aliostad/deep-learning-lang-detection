(function($){
	
	$(document).ready(function() {
		
		var showNav = sliderOptions['directionNav'] == 1 ? true : false ;
		var showNavHover = sliderOptions['directionNavHide'] == 1 ? true : false ;
		console.log(showNav, showNavHover);
	
		 $('#slider').nivoSlider({
			effect: sliderOptions['transition'],
			animSpeed: sliderOptions['animSpeed'], // Slide transition speed
			pauseTime: sliderOptions['pauseTime'],
			directionNav : showNav,
			directionalNavHide : showNavHover,
			controlNav: true,
			controlNavThumbs: true,
			captionOpacity: sliderOptions['opacity']
		});
	});
	
})(jQuery);
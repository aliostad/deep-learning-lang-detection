$(document).ready(function(){
	//get the bottom position of nav bar
	var navPosYTop = $('nav').offset().top;
	var navPosYBottom = $('nav').offset().top + $('nav').height();
	//listen for scrolling
	var $w = $(window);
	$w.scroll(function(){
		var scrollPosition = $w.scrollTop();
		if (scrollPosition > navPosYTop){
			if($('nav').hasClass('fixedNav') == false){
				$('nav').addClass('fixedNav');
				$('.contents').css("margin-top",$('nav').height()+"px");
			}
		}
		if(scrollPosition<=navPosYTop && $('nav').hasClass('fixedNav')==true){
			$('nav').removeClass('fixedNav');
			$('.contents').css("margin-top","0px");
		}
	});
});
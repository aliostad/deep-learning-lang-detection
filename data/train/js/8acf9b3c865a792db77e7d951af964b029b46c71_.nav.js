/*Main Navigation*/

	/*hiding nav*/
	$.hideNav = function(event) {
		$('nav li').removeClass('active');	
	}
	/*show nav*/
	$.showNav = function(target) {
		if(target.hasClass('active')) {
			$.hideNav();
		}
		else {
			$('nav li').removeClass('active');
			target.addClass('active');
		}
	}
	/*Navigation event controller*/
	$('nav').find('a.dropdown').click(function(e){
		e.stopPropagation();
		e.preventDefault();
		$.showNav($(this).parent('li'));
	});
	/*hiding nav on clicking outside*/
	$('html').click(function(e){
		$.hideNav();
		if($('.main-nav').hasClass('show')){
			$('.main-nav').removeClass('show');
		}
	});
	/*mobile navigation*/
	$('.hamburger').click(function(e){
		var $mainNav = $('.main-nav');
		if($($mainNav).hasClass('show')){
			$mainNav.removeClass('show');
		}
		else {
			$mainNav.addClass('show');
		}
		e.stopPropagation();
	});



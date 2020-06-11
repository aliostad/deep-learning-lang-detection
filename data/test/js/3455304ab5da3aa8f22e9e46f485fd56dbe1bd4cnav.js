$(document).ready(function(){
	offsetTitle = 150;
	offsetNav = 150;
	$pageNav = $('.pageNav');
	pageNavHeight = $pageNav.outerHeight();
	windowHeight = $(window).height();
	$mobileNavButton = $('.mobileMenuButton');

	pageNavPosition = windowHeight - pageNavHeight;

	if (pageNavPosition > 662) {
		pageNavPosition = 662;
	}

	$pageNav.css('top', pageNavPosition);

	$(window).scroll(function(){
		if ($(this).scrollTop() >= (-offsetTitle + pageNavPosition)) {
			$('.pageTitle').addClass('fixed');
		} else {
			$('.pageTitle').removeClass('fixed');
		}

		if ($(this).scrollTop() >= (-offsetNav + pageNavPosition)) {
			$('.pageNav').addClass('fixed');
		} else {
			$('.pageNav').removeClass('fixed');
		}
    });

    $mobileNavButton.click(function() {
    	$pageNav.toggleClass('showMobileMenu');
    });

    $('.pageNav a').click(function() {
    	$pageNav.removeClass('showMobileMenu');
    })

});
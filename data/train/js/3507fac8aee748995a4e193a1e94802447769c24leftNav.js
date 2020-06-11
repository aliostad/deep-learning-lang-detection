//////////////////////////////////////////////////////////////////////
// Навигация в сайдбаре
//////////////////////////////////////////////////////////////////////

$(".left-nav-2").children("a").click(function(e){
	e.preventDefault()
});

$('.left-nav-2').click(function() {
	var toggleOptons = {
		duration: 300,
		easing: 'swing'
	}
	
	$('.left-nav-2').not(this).removeClass('left-nav-opened');
	$('.left-nav-2').not(this).removeClass('left-nav-closed');
	$('.left-nav-2').not(this).addClass('left-nav-closed');

	if ($(this).hasClass('left-nav-closed')) {
		$(this).removeClass('left-nav-closed');
		$(this).addClass('left-nav-opened');
		$(this).find('ul').toggle(toggleOptons);
	}
	else if ($(this).hasClass('left-nav-opened')){
		$(this).removeClass('left-nav-opened');
		$(this).addClass('left-nav-closed');
	}
	else{
		$(this).addClass('left-nav-opened');
		$(this).find('ul').toggle(toggleOptons);
	}

	$('.left-nav-closed ul').hide(300);
});
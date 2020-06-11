$('.enable-nav').click(function ()
{
	if($(this).is('.active'))
	{
		// hide nav
		$(this).removeClass('active');
		$('body > header nav').removeAttr('style');
	}
	else
	{
		// show nav
		var height, nav, ul;

		nav = $('body > header nav');
		ul = nav.children('ul');
		height = ul.outerHeight();

		$(this).addClass('active');
		nav.css('height', height + 'px');
	}
});

$('body > header nav a').click(function ()
{
	if ($('.enable-nav').is('.active'))
	{
		$('.enable-nav').removeClass('active');
		$('body > header nav').css('height', 0 + 'px');	
	}
});
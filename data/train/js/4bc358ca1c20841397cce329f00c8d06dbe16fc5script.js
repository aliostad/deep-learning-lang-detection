$('nav#NavPanel > ul > li').not('.home').click(function(event) {
	event.stopPropagation();
	$(this).parent().addClass('hide');
	$(this).find('ul').addClass('show');
	$('nav#NavPanel .backButton').css('display', 'inline-block');
	return false;
});

$('nav#NavPanel .backButton').click(function() {
	$('nav#NavPanel > ul').removeClass('hide');
	$('nav#NavPanel ul li ul.show').removeClass('show');
	$('nav#NavPanel .backButton').hide();
});

/*
	Knop om het menu te openen en sluiten
*/
$('#menuButton').click( function() {
	var $navPanel = $('#NavPanel');
	if ( $navPanel.hasClass('show') ) {
		$navPanel.removeClass('show');
	} else {
		$navPanel.addClass('show');
	}
	
});
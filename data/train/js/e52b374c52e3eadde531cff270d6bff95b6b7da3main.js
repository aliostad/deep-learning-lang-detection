$(document).ready(function(){
	/* Extended the navigation bar across the whole window and centralises the items. */
	var nav_width = parseInt($('nav').css('width'));
	var document_width = parseInt($(document).width());
	var nav_padding = (document_width - nav_width) / 2;
	var nav_items_width = 0;
	var nav_items = [];
	$('.nav_item').each(function(i){
		nav_items_width += i;
		nav_items[i] = $(this).width();
		nav_items_width += nav_items[i];
		nav_items_width += parseInt($(this).css('padding-left'));
		nav_items_width += parseInt($(this).css('padding-right'));
	});
	var nav_additional_padding = (nav_width - nav_items_width) / 2;
	$('nav').css({
		'margin-left' : '-'+nav_padding+'px',
		'padding-left' : (nav_padding + nav_additional_padding)+'px',
		'padding-right' : (nav_padding + nav_additional_padding)+'px',
		'width' : nav_items_width
	});
	if($.browser.msie && $.browser.version.substr(0,1) < 8){
		$('.nav_item').each(function(i){
			$(this).css('width', nav_items[i]);
		});
	}
	
	/* Allows the user to click any part of the social network item to open the link */
	$('.nav_item').css('cursor', 'pointer');
	$('.nav_item').click(function(){
		window.location = $(this).find('a').attr('href');
		return false;
	});
});
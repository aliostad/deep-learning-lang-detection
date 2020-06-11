function show_alert(msg, seconds, failure, under) {
	clearTimeout(show_alert.timer);
	show_alert.under = under;
	
	if (typeof show_alert.div == 'undefined') {
		show_alert.div = $(document.createElement('div'));
		show_alert.div.addClass("alert");
		$('body').append(show_alert.div);
		show_alert.div.css('line-height', '20px');
		show_alert.div.click(function () {
			clearTimeout(show_alert.timer);
			show_alert.div.hide();
		});
	}

	// reset left and top so the message wraps properly when we call html()
	show_alert.div.hide();
	show_alert.div.css('left', '0px');
	show_alert.div.css('top', '0px');
	
	// load in the message
	show_alert.div.html(msg);

	// set the failed class if appropriate
	if (failure) show_alert.div.addClass('failed');
	else show_alert.div.removeClass('failed');
	
	// show the message
	show_alert.div.show();
	
	// position the alert
	show_alert_adjustorigin();
			
	// optionally hide the message after a given amount of time
	if (seconds > 0) {
		show_alert.timer = setTimeout(function () { show_alert.div.hide(); }, seconds*1000);
	}
}

function show_alert_adjustorigin() {
	if (typeof show_alert.div == 'undefined' || show_alert.div.is(':hidden')) return;
	var under = show_alert.under;
	// position the message under the given element
	show_alert.div.css('left', (under.offset().left + under.outerWidth() - show_alert.div.outerWidth())+'px');
	show_alert.div.css('top', (under.offset().top + under.outerHeight() + 1)+'px');
	// if the message would be offscreen, move it left
	if (window.innerWidth+$(window).scrollLeft() < show_alert.div.offset().left + show_alert.div.outerWidth()) {
		show_alert.div.css('left', (window.innerWidth+$(window).scrollLeft()-show_alert.div.outerWidth())+'px');
	}
	// if the message would be offscreen, move it up
	if (window.innerHeight+$(window).scrollTop() < show_alert.div.offset().top + show_alert.div.outerHeight()) {
		show_alert.div.css('top', (window.innerHeight+$(window).scrollTop()-show_alert.div.outerHeight())+'px');
	}
}

$(window).resize(show_alert_adjustorigin);
$(window).scroll(show_alert_adjustorigin);

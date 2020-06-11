var show_index = null;

/*
 * Display the specified show and update the
 * current show_index.
 */
var display_show = function(index) {
	Setlist.display_show(index)
		.done(function(new_index) {
			show_index = new_index;
			check_arrows();
		});
};

$(document).ready(function() {
	display_show(null);

	Setlist.generate_show_dropdown(0)
		.done(function(el) {
			el.addClass('show-select');
			var container = $('<div>')
				.addClass('show-pick-container')
				.append(el)
				.appendTo('header')
				.change(show_dropdown_change);
		});

	$('.arrow.left').click(function(e) {
		e.preventDefault();
		display_show(--show_index);
	});
	$('.arrow.right').click(function(e) {
		e.preventDefault();
		display_show(++show_index);
	});
});

var show_dropdown_change = function() {
	var new_show_index = $('.show-select')[0].selectedIndex;
	if (show_index != new_show_index)
		display_show(new_show_index);
};

var check_arrows = function() {
	if (show_index == 0)
		$('.arrow.left').hide();
	else
		$('.arrow.left').show();
	if (show_index == Cache.shows.length - 1)
		$('.arrow.right').hide();
	else
		$('.arrow.right').show();
};

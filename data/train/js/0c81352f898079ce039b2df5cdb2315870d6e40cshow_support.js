'use strict';

$(document).ready(function() {
	initializePage();
});

function initializePage() {
	$('.show-support-btn').click(showSupport);
}

function showSupport(e) {
	e.preventDefault();

	var storyId = $(this).attr("story-id");
	var url = '/story/show_support/' + storyId;

	$.get(url, function(response) {
		$('.stand-with-count').text(response.stand_with_count);
		$('.show-support-btn .support-cta').hide();
		$('.show-support-btn .supported-msg').show();
		$('.show-support-btn').unbind('click');
	});
}
$(document).ready(function() {
	$('#basecamp').hover(function() {
		$('.headings').hide();
		$('#basecamp-heading').show();
		$('#arrowl').show();
	},function(){
		$('#basecamp-heading').hide();
		$('#intro').show();
		$('#arrowl').hide();
	});

	$('#highrise').hover(function() {
		$('.headings').hide();
		$('#highrise-heading').show();
		$('#up-arrow').show();
	},function(){
		$('#highrise-heading').hide();
		$('#intro').show();
		$('#up-arrow').hide();
	});

	$('#campfire').hover(function() {
		$('.headings').hide();
		$('#campfire-heading').show();
		$('#right-arrow').show();
	},function(){
		$('#campfire-heading').hide()
		$('#intro').show();
		$('#right-arrow').hide();
	});
});

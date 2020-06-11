$(function(){

	$('#basecamp').hover(function(){
		$('.basecamp').show();
		$('#bc-arrow').show();
		$('#main').hide();
		}, function(){
		$('.basecamp').hide();
		$('#bc-arrow').hide();
		$('#main').show();
	});

	$('#highrise').hover(function(){
		$('.highrise').show();
		$('#hr-arrow').show();
		$('#main').hide();
		}, function(){
		$('.highrise').hide();
		$('#hr-arrow').hide();
		$('#main').show();
	});

	$('#campfire').hover(function(){
		$('.campfire').show();
		$('#cf-arrow').show();
		$('#main').hide();
		}, function(){
		$('.campfire').hide();
		$('#cf-arrow').hide();
		$('#main').show();
	});

});

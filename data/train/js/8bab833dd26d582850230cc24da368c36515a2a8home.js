$(document).ready(function(){

	$('#account_nav').hide();
	$('#inbox').hide();
	$('#profile_sub_nav').hide();
	$('#networks_sub_nav').hide();
	$('#interests_sub_nav').hide();
	$('#services_sub_nav').hide();
	
	

	$('#messages').mouseenter(function(){
		$('#invitations_count').hide();
	});

	$('#messages').mouseleave(function(){
		$('#invitations_count').show();
	});



	$('#profile_pic').mouseenter(function(){
		$('#account_nav').show();
		$('#business_nav').hide();
	});

	$('#profile_actions').mouseleave(function(){
		$('#account_nav').hide();
		$('#business_nav').show();
	});



	$('#messages').mouseenter(function(){
		$('#inbox').show();
		$('#business_nav').hide();
	});

	$('#messages').mouseleave(function(){
		$('#inbox').hide();
		$('#business_nav').show();
	});



	$('#profile_nav').mouseenter(function(){
		$('#profile_sub_nav').fadeIn("fast");
	});

	$('#profile_nav').mouseleave(function(){
		$('#profile_sub_nav').hide();
	});



	$('#networks_nav').mouseenter(function(){
		$('#networks_sub_nav').fadeIn("fast");
	});

	$('#networks_nav').mouseleave(function(){
		$('#networks_sub_nav').hide();
	});



	$('#interests_nav').mouseenter(function(){
		$('#interests_sub_nav').fadeIn("fast");
	});

	$('#interests_nav').mouseleave(function(){
		$('#interests_sub_nav').hide();
	});



	$('#services_nav').mouseenter(function(){
		$('#services_sub_nav').fadeIn("fast");
	});

	$('#services_nav').mouseleave(function(){
		$('#services_sub_nav').hide();
	});

});
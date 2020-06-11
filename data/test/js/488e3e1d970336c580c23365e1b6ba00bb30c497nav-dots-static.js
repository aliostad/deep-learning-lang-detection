$(document).ready(function(){

/****************Init********************
    $('#nav-dot-home a').addClass('nav-dot-active');
*/
	$(function() {
		var loc = window.location.href; // returns the full URL
		if(/blue-lightning-rod/.test(loc)) {
	    $('#nav-dot-home a').removeClass('nav-dot-active');
		$('#nav-dot-blue-lightning a').addClass('nav-dot-active');
		}
	});
	
	$(function() {
		var loc = window.location.href; // returns the full URL
		if(/three-reasons/.test(loc)) {
	    $('#nav-dot-home a').removeClass('nav-dot-active');
		$('#nav-dot-three-reasons a').addClass('nav-dot-active');
		}
	});
	
	$(function() {
		var loc = window.location.href; // returns the full URL
		if(/anode-rod-life-cycle/.test(loc)) {
	    $('#nav-dot-home a').removeClass('nav-dot-active');
		$('#nav-dot-working-anode a').addClass('nav-dot-active');
		}
	});
	
  });
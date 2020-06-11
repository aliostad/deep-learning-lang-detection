var $nav = $('#nav');
var $logo = $('#steelstyle');
var $nav_content = $('#nav-content');
$(window).scroll(function(){
	var $scroll = $(window).scrollTop();
	if ($scroll < 20) {
		$nav.addClass("untoggleNav").removeClass("toggleNav");
		$logo.addClass("untoggledLogo");
		$nav_content.removeClass("collapsedNav");
	} else {
		$nav.removeClass("untoggleNav").addClass("toggleNav");
		$nav_content.addClass("collapsedNav");
		$logo.removeClass("untoggledLogo");
	}
});
$(function(){
	$('#navbutton').on('click',function(){		
        $('#nav-content').toggle('slide');
	});
});
$(document).ready(function() {

    // page is now ready, initialize the calendar...

    $('#calendar').fullCalendar({
        // put your options and callbacks here
    })

});
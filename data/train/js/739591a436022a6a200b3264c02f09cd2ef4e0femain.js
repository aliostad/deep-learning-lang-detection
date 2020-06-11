$(window).load(
	function() {

		$(window).scrollTop(0);

		$(window).resize(function() {
			$('#nav ul.links li, #nav ul.social').removeAttr('style');
		});

    }

);

var toggleNav = function(x, open) {
    if (open) {
        $('#nav ul.links li, #nav ul.social').css('display', 'none');
        x.setAttribute('onclick', "javascript:toggleNav(this, false);")
    }
		
	else {
    	$('#nav ul.links li, #nav ul.social').css('display', 'block');
    	x.setAttribute('onclick', "javascript:toggleNav(this, true);")
	}
}


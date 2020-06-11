/* ==============================================
= 				ON DOM READY 					=
================================================*/

$(function() {
    $('.toggle-nav').click(function(event) {
        toggleNav();
    });

    $(document).keyup(function(event) {
    	if(event.keyCode == 27) {
    		if ($('#site-wrapper').hasClass('show-nav')) {

    			toggleNav();
    		};
    	}
    });
});

/* ==============================================
= 				CUSTOM FUNCTIONS				=
================================================*/


function toggleNav() {
	
	if($('#site-wrapper').hasClass('show-nav')) {
		// Do things on Nav Close
		$('#site-wrapper').removeClass('show-nav');
	} else {
		// Do things on Nav Open
		$('#site-wrapper').addClass('show-nav');		
	}
	// $('#site-wrapper').toggleClass('show-nav');
}

function toggleNavOld() {
    if ($('#site-wrapper').hasClass('show-nav')) {
        $('#site-wrapper').css('margin-right', '0px');
        $('#site-wrapper').removeClass('show-nav');
    } else {  
        $('#site-wrapper').css('margin-right', '-300px');
        $('#site-wrapper').addClass('show-nav');
    }

    //$('#site-wrapper').toggleClass('show-nav');
}
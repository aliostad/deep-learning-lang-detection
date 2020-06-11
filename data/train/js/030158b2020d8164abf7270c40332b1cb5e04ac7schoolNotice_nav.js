/**
 * Javascript for the school notice menu navigation action.<br/>
 * When button is clicked, the navigation is shown or hidden. <br/>
 * The ids of show and hide button must be "school_nav-show" and "school_nav-hide", respectively.<br/>
 * The id of the div tag including navigation must be "class_nav".<br/>
 * @param nothing
 * @returns nothing.
 */
function addSchoolNoticeNavScript()
{
	$('#school_nav').hide();
	$('#school_nav-show').show();
	$('#school_nav-hide').hide();
	$('#school_nav-show').click(function(){
		$('#school_nav-show').toggle();
		$('#school_nav-hide').toggle();
		$('#school_nav').slideDown();
	});
	$('#school_nav-hide').click(function(){
		$('#school_nav-hide').toggle();
		$('#school_nav-show').toggle();
		$('#school_nav').slideUp();
	});
}	
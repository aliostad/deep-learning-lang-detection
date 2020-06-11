/**
 * Javascript for the menu navigation action.<br/>
 * When button is clicked, the navigation is shown or hidden. <br/>
 * The ids of show and hide button must be "nav-show" and "nav-hide", respectively.<br/>
 * The id of the div tag including navigation must be "nav".<br/>
 * @param nothing
 * @returns nothing.
 */
function addNavScript()
{
	$('#nav').hide();
	$('#nav-show').show();
	$('#nav-hide').hide();
	$('#nav-show').click(function(){
		$('#nav-show').toggle();
		$('#nav-hide').toggle();
		$('#nav').slideDown();
	});
	$('#nav-hide').click(function(){
		$('#nav-hide').toggle();
		$('#nav-show').toggle();
		$('#nav').slideUp();
	});
}

	
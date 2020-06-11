/**
 * Javascript for the class menu navigation action.<br/>
 * When button is clicked, the navigation is shown or hidden. <br/>
 * The ids of show and hide button must be "class_nav-show" and "class_nav-hide", respectively.<br/>
 * The id of the div tag including navigation must be "class_nav".<br/>
 * @param nothing
 * @returns nothing.
 */
function addClassNavScript()
{
	$('#class_nav').hide();
	$('#class_nav-show').show();
	$('#class_nav-hide').hide();
	$('#class_nav-show').click(function(){
		$('#class_nav-show').toggle();
		$('#class_nav-hide').toggle();
		$('#class_nav').slideDown();
	});
	$('#class_nav-hide').click(function(){
		$('#class_nav-hide').toggle();
		$('#class_nav-show').toggle();
		$('#class_nav').slideUp();
	});
}	
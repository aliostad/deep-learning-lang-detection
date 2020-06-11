/*global $*/

$(nav);

function nav() {

    var _nav_link_holder = $('ul.nav'),
	_nav_content_holder = $('.nav-content');

    function hideAllNavContent() {
	_nav_content_holder.children().hide();
    }

    function deactivateNavLinks() {
	_nav_link_holder.children().removeClass('active');
    }

    function registerNavActions() {
	$('ul.nav > li > a').click(function(e) {
	    e.preventDefault();
	    hideAllNavContent();
	    deactivateNavLinks();
	    $('.nav-content').find($(this).attr('href')).show();
	    $(this).parent().addClass('active');
	});
    }

    function activateFirstNavLink() {
	_nav_link_holder.find('li > a').first().trigger('click');
    }

    (function() {
	hideAllNavContent();
	deactivateNavLinks();
	registerNavActions();
	activateFirstNavLink();
    })();

}

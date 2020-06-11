window.onload = function() {
	// navigation control;
	var navBtn = document.getElementById('nav-button');
	var navTag = document.getElementById('nav-tag');
	var	nav = document.getElementById('nav-main');
	var wrapper = document.getElementById('wrapper');

	window.EventUtil.addHandler(navBtn, 'click', navHandler);
	function navHandler(event) {
		classie.toggle( nav, 'open-state' );
		classie.toggle( navBtn, 'left-fix' );
		classie.toggle( navTag, 'fa-bars' );
		classie.toggle( navTag, 'fa-times' );
		event.preventDefault();
	}
};

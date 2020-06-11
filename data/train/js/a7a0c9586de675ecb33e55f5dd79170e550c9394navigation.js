jQuery(function($){ // DOM is now read and ready to be manipulated

    var navTrigger = $('#nav-toggle');
    var nav = $('.nav');

    function toggleNav(event) {

    	event.preventDefault();
    	nav.toggleClass('nav--is-active');

    }

    navTrigger.on('click', toggleNav);

});
// (function() {

// 	var navTrigger = $('#nav-toggle');
// 	var nav = $('.nav');

// 	function toggleNav() {

// 		nav.toggleClass('nav--is-active');

// 	}

// 	navTrigger.on('click', toggleNav);



// })();

// (function() {

// 	alert('This is an alert');

// })();
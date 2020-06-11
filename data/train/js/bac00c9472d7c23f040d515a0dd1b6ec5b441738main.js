

//	Mobile Navigation
(function() {
    
    
    var navToggle = $('.nav-toggle');
    var nav = $('.nav');
    
    
    

    // function rotateIcon() {
    // 	$('.nav-toggle').toggleClass('nav--open');
    // }

    // function openNavDrawer(event) {
    //     event.preventDefault();	
    //     navToggle.toggleClass('rotate--icon');
    //     nav.toggleClass('nav--open');

    // }

  //   function closeNavDrawer(event) {
  //       event.preventDefault();	
  //       navToggle.removeClass('nav--open');
  //       navToggle.on('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function(){

		// 	$('.nav').toggleClass('nav--open');
		// });

  //   }

  	function whichTransitionEvent(){
  	  var t,
  	      el = document.createElement("fakeelement");

  	  var transitions = {
  	    "transition"      : "transitionend",
  	    "OTransition"     : "oTransitionEnd",
  	    "MozTransition"   : "transitionend",
  	    "WebkitTransition": "webkitTransitionEnd"
  	  };

  	  for (t in transitions){
  	    if (el.style[t] !== undefined){
  	      return transitions[t];
  	    }
  	  }
  	}

  	var transitionEvent = whichTransitionEvent();
  	

    navToggle.on('click', function() {

    	 event.preventDefault();

    	 navToggle.toggleClass('rotate--icon').one(transitionEvent,

	 		function(){
	 			toggleMenu();
	 		});
    });

    function toggleMenu() {
    	nav.toggleClass('nav--open');
    }


})();


// navToggle.on('click', openNavDrawer);



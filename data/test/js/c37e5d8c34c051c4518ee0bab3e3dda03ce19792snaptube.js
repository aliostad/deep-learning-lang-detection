
(function () {
	var UA = window.navigator.userAgent;
	var CLICK = 'click';
	if(/ipad|iphone|android/.test(UA)){
		CLICK = 'tap';
	}
	// body...
	var wrapper = $(".site-nav"),
  	    toggleNav = $(".toggle-nav"),
  	    mainNav = $(".main-nav"),
  	    mask = $(".mask"),
  	    category = $("li.category a"),
  	    categorySub = $("li.category .sub"),
  	    closeMenu = $(".main-nav .close");

  	var zWin = $(window);
  	var zDoc = $(document);
  	var docH = zDoc.height();

  	toggleNav[CLICK](function(e){
  		e.preventDefault();
  		$(this).hide();
  		mainNav.addClass("gbzp");
  		mainNav.height(docH+'px');
  		mask.height(docH+'px');
  		mask.show();
	});

  	mask[CLICK](function(e){
  		e.preventDefault();
		toggleNav.show();
		mainNav.removeClass('gbzp');
		mask.hide();
  	});

	mainNav.swipeLeft(function(){
		toggleNav.show();
		mainNav.removeClass("gbzp");
		mask.hide();
	});


})();
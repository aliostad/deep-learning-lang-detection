jQuery("document").ready(function($){
    
    var navWrapper = $('#nav-wrapper');
    var nav = $('#nav-wrapper .container');
	var navScrollTriggerPx = 126;
	
	var serviceWrapper = $('.view-services .attachment');
    var serviceNav = $('.view-services .attachment .view-content');
	var serviceScrollTriggerPx = 160;
    
    $(window).scroll(function () {
        if ($(this).scrollTop() > navScrollTriggerPx) {
            nav.addClass("locked");
			navWrapper.height(nav.height())
        } else {
            nav.removeClass("locked");
			navWrapper.height('auto')
        }
		
		if ($(this).scrollTop() > serviceScrollTriggerPx) {
            serviceNav.addClass("serviceLocked");
			serviceWrapper.height(serviceNav.height())
        } else {
            serviceNav.removeClass("serviceLocked");
			serviceWrapper.height('auto')
        }
    }); 
});
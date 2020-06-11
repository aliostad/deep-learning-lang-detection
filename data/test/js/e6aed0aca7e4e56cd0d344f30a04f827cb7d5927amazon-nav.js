var amazonNav = {
    // amount of time (in ms) for mouse to hover before opening subnav the first time
    navEnterTimeout : 200,

    // amount of time (in ms) for mouse to hover before opening a new subnav
    // "grazing the corner"
    mouseoverTimeout : 120,

    pauseBeforeOpening : false,

	init : function() {

            // mouse entered main nav
            $('ul.primary-nav>li').bind('mouseenter', function(e){
                // if we are on the large screen
                if ( $('#nav-toggle').css('display') == 'none' ) {
                    var navIndex = $(this).index();
                    if ( amazonNav.pauseBeforeOpening ) {
                        // the nav is already open, but mouse went over new main nav item
                        // don't open immediately in case they are mousing over a main nav corner
                        amazonNav.pauseBeforeOpening = false;
                        setTimeout(function(){
                            if ( $(e.target).is(":hover") ) {
                                amazonNav.openNavItem(navIndex);
                            }
                        }, amazonNav.mouseoverTimeout);
                    } else {
                        // the subnav is not open yet
                        // don't open immediately in case they are mousing over the main nav
                        setTimeout(function(){
                            if ( $(e.target).is(":hover") ) {
                                amazonNav.openNavItem(navIndex);
                            }
                        }, amazonNav.navEnterTimeout);
                    }
                }
            });

            // touchdown main nav
            $('ul.primary-nav>li').bind('touchstart', function(e){
                if ( $('#nav-toggle').css('display') == 'none' ) {
                    e.preventDefault();
                    var navIndex = $(this).index();
                    if ( amazonNav.pauseBeforeOpening ) {
                        amazonNav.pauseBeforeOpening = false;
                    }
                    if ( $(this).find('a').hasClass('open') ) {
                        // they already have the nav open so open the main nav item
                        window.open( 'http:' + $(this).find('a').attr('href'),'_self' );
                    } else {
                        // the subnav is not open yet
                        // don't open immediately in case they are mousing over the main nav
                        setTimeout(function(){
                            amazonNav.openNavItem(navIndex);
                        }, amazonNav.navEnterTimeout);
                    }
                }
            });
        
            $(document).bind('touchstart', function(e) {
                if ( $(e.target).closest('ul.primary-nav').length === 0 && $(e.target).closest('.primary-menu-list').length === 0 && $('ul.primary-nav>li>a').hasClass('open') && $('#nav-toggle').css('display') == 'none' ) {
                    e.preventDefault();
                    amazonNav.closeNav();
                }
            });


            // mouse left the main nav
            $('ul.primary-nav>li').bind('mouseleave', function(e){
                if( $(e.toElement || e.relatedTarget).hasClass('primary-menu-item') ) {
                    // mouse left the nav and went into another one
                    // set variable so that it doesn't open immediately
                    amazonNav.pauseBeforeOpening = true;
                } else if ( ! $(e.toElement || e.relatedTarget).hasClass('primary-menu-list') ) {
                    // mouse left the menu completely
                    amazonNav.closeNav();
                }
            });

            // mouse left the subnav
            $('.primary-menu-list').bind('mouseleave', function(e){
                if( ! $(e.toElement || e.relatedTarget).hasClass('primary-menu-item') ) {
                    // mouse left the nav completely
                    amazonNav.closeNav();
                }
            });
        

	},


    closeNav : function() {
        $('.primary-menu-item').removeClass('open');
        $('.primary-menu-list').removeClass('open');
    },

    openNavItem : function(navIndex) {
        // closing all nav will avoid nav items stacking on each other
        amazonNav.closeNav();
        $('.primary-menu-item:eq(' + navIndex + ')').addClass('open');
        $('.primary-menu-list:eq(' + navIndex + ')').addClass('open');
    }

};

jQuery(function(){
    amazonNav.init();
});
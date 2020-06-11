window.addEvent('domready', function() {
    if ( !$('navBar') ) {
        if( $('inlineNavMenu') ) {
            $('inlineNavMenu').addClass('inactiveMenu');
        }
    } else {
        var navBarLocked = ( Cookie.read('iHRIS_NavMenuLock') ? 1 : 0 );
        var navBarSeen = ( Cookie.read('iHRIS_NavMenuShow') ? 1 : 0 ) && navBarLocked;
        processNavLock = function() {
            var lockElement = $('inlineNavMenuLock');
            if ( lockElement ) {
                if ( navBarLocked ) {
                    lockElement.addClass('open');
                    Cookie.write('iHRIS_NavMenuLock', 1, { duration: 30 });
                } else {
                    lockElement.removeClass('open');
                    Cookie.dispose('iHRIS_NavMenuLock');
                    Cookie.dispose('iHRIS_NavMenuShow');
                }
            }
        }
        processNavMenu = function() {
            var outerElement = $('siteOuterWrap');
            var inlineMenu = $('inlineNavMenu');
            if ( outerElement && inlineMenu ) {
                if ( navBarSeen ) {
                    outerElement.removeClass('autoHideNav');
                    inlineMenu.addClass('open');
                } else {
                    outerElement.addClass('autoHideNav');
                    inlineMenu.removeClass('open');
                }
            }
        }
        toggleLock = function() {
            navBarLocked = !navBarLocked;
            processNavLock();
        }
        toggleMenu = function() {
            navBarSeen = !navBarSeen;
            processNavMenu();
            Cookie.dispose('iHRIS_NavMenuShow');
            if ( navBarLocked ) {
                Cookie.write('iHRIS_NavMenuShow', navBarSeen, { duration: 30 });
            }
        }
        processNavLock();
        processNavMenu();
        if ( $('inlineNavMenu') ) {
            $('inlineNavMenu').addEvent('click', toggleMenu );
            if ( $('inlineNavMenuLock') ) {
                $('inlineNavMenuLock').addEvent('click', function(ev) {
                    toggleLock();
                    ev.stop();
                });
            }
        }
    }
});

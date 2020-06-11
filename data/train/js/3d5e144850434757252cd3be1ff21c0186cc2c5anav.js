$(function() {
    // Stick the #nav to the top of the window
    var nav = $('#nav');
    var navWrap = $('#nav-wrap');
    var navHomeY = nav.offset().top;
    var isFixed = false;
    var $w = $(window);
    var navNumber = $('.number');
    $w.scroll(function() {
        var scrollTop = $w.scrollTop();
        var shouldBeFixed = scrollTop > navHomeY;
        if (shouldBeFixed && !isFixed) {
            nav.css({
                width: '88%',
                position: 'fixed',
                'z-index': 10,
                top: 0,
//                left: nav.offset().left,
//                width: 'nav.width()',
                height: '71px',
                boxShadow: '0px 2px 10px #E0E0E0'
            });
            isFixed = true;
            nav.addClass('nav-smaller');

            navWrap.css({ height: '71px'});
            navWrap.addClass('nav-smaller');
        }
        else if (!shouldBeFixed && isFixed)
        {
            nav.css({
                width: '100%',
                position: 'static',
                boxShadow: 'none',
                height: '114px'
            });
            isFixed = false;
            nav.removeClass('nav-smaller');
            navWrap.removeClass('nav-smaller');
            navWrap.css({ height: '114px' });
        }
    });
});
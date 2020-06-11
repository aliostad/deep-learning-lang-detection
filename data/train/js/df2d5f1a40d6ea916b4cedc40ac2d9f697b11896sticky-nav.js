define(['jquery', 'domReady!'], function(){
    var $window = $(window),
        $navAnchor = $('#nav-anchor'),
        $nav = $('#nav-sticky');
        // $header = $('header');

    $window.scroll(function() {
        var window_top = $window.scrollTop();
        var nav_top = $navAnchor.offset().top;
        if (window_top > nav_top) {
            $nav.addClass('fixed');
            $navAnchor.height($nav.height());
        } else {
            $nav.removeClass('fixed');
            $navAnchor.height(0);
        }
    });
});
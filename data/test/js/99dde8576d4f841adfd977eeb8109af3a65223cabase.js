$(document).ready(function() {
    
    var $nav = $('.navbar'),
        $navAnchor = $('.navbar-anchor'),
        $body = $('body'),
        $window = $(window),
        navOffsetTop = $nav.offset().top

    function init() {
        $window.on('scroll', onScroll);
    }

    function onScroll() {
        if(navOffsetTop < $window.scrollTop() && !$nav.hasClass('is-docked')) {
            $nav.addClass('is-docked');
            $navAnchor.height($nav.height());
        }
        if(navOffsetTop > $window.scrollTop() && $nav.hasClass('is-docked')) {
            $nav.removeClass('is-docked');
            $navAnchor.height(0);
        }
        if($window.scrollTop() === 0) {
            $nav.removeClass('is-docked');
            $navAnchor.height(0);
        }
    }

    init();

});

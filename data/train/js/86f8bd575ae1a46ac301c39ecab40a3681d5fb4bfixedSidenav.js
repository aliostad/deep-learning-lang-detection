(function ($, undefined) {
    var nav,
        navHeight,
        $window,
        doc,
        boundTop,
        boundBottom;

    $(function () {
        cacheElements();

        $window.scroll(function () {
            var left = (window.pageXOffset || doc.scrollLeft) - (doc.clientLeft || 0);
            var top = (window.pageYOffset || doc.scrollTop) - (doc.clientTop || 0);

            var navTop = nav.offset().top,
                navBottom = navTop + navHeight;
            
            nav.css('top', top - navHeight);

            navTop = nav.offset().top;
            navBottom = navTop + navHeight;

            if (navTop < boundTop)
                nav.css('top', 0);

            if(navBottom > boundBottom)
                nav.css('top', boundBottom - navHeight);

        });
    });

    function cacheElements() {
        nav = $('.lq-fixed-sidenav');
        navHeight = nav.outerHeight();

        boundTop = $('.lq-fixed-sidenav-container').offset().top;
        boundBottom = $('#lq-footer').offset().top - 20;

        console.log(boundBottom);

        $window = $(window);
        doc = document.documentElement;
    }
})(jQuery);
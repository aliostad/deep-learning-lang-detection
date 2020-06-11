$(document).ready(function() {

    var $body = $('body'),
        desktopBreak = 768,
        maxNavHeight = 38,
        $topNav = $('#tdr_nav'),
        $window = $(window),
        $search = $topNav.find('.tdr_search'),
        $navList = $('.tdr_nav_list'),

    /* do we have a nav menu? */
        hasNav = false;


    if ($navList.find('> li').length > 0) {
        hasNav = true;
    }

    if (hasNav) {
        /* init nav menu */
        $navList.superfish({
            cssArrows: false
        });
    } else {
        /* hide menu icon */
        $("#tdr_title_menu_link").attr("style", "display: none");
        $("#tdr_title_content").addClass("noMenu");
    }

    /* search link */
    $("#tdr_search_toggle").click(function(event) {
        $search.toggleClass("show");
    });

    $(".navbar-toggle").on("click", function() {
        $body.toggleClass("active");
    });

    function navMover() {
        if ($window.width() >= desktopBreak) {
            if ($body.hasClass("active")) {
                $body.removeClass("active");
            }

            if ($topNav.height() > maxNavHeight ) {
                $body.addClass('collapse-nav');
            } else {
                $body.removeClass('collapse-nav');
            }
        }

        if ($window.width() < desktopBreak && $body.hasClass("collapse-nav")) {
            $body.removeClass("collapse-nav");
        }
    }

    FastClick.attach(document.body);
    $window.on('load orientationchange resize', navMover);
});
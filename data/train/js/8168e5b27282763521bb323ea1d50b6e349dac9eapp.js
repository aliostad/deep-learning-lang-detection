
define([
    './router',
    './contact'
], function(router, contact) {
    var my = {};

    var animateTime = 500;

    my.init = function() {
        router.init();

        contact.init();

        bindNavEvents();
    };

    function bindNavEvents() {

        var $nav = $('.navbar');

        $nav.data('original-height', $nav.height());
        $nav.data('link-count', $('.nav-right li').size());

        $('.expand-nav-btn').click(function() {

            var $expandedNav = $('.expanded-nav');
            var callback = function() {
                $expandedNav.toggleClass('expanded');
            }

            if ($expandedNav.is('.expanded')) {
                shrinkNav($nav, function() {
                    $expandedNav.hide();
                    callback();
                });
            } else {
                $expandedNav.show();
                expandNav($nav, function() {
                   callback();
                });
            }
        });
    }

    function shrinkNav($nav, callback) {
        var originalHeight = $nav.data("original-height");
        $nav.animate({
            height: originalHeight + 'px'
        }, animateTime);
        $('.main-content').animate({
            top: originalHeight + 'px'
        }, animateTime, callback);
    }

    function expandNav($nav, callback) {
        var linkHeight = 42;
        var expandedHeight = $nav.data('original-height') +
            ($nav.data('link-count') * linkHeight);
        $nav.animate({
            height: expandedHeight + 'px'
        }, animateTime);
        $('.main-content').animate({
            top: expandedHeight + 'px'
        }, animateTime, callback);
    }

    return my;
});

 

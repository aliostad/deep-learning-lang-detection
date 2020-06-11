$(document).ready(function() {
    var navMain = '#nav';
    var navActive = 'active';

    $('.nav-button').click(function() {
        $(this).toggleClass('open');

        if ($(navMain).hasClass(navActive)) {
            $(navMain).stop().animate({height:0},300);
            setTimeout(function(){
                $(navMain).removeClass(navActive).removeAttr('style');
            },300);
        } else {
            var navHeight = $(navActive).stop().height($(window).height() - 124 );
            $(navMain).height(0).animate({height:navHeight},250);
            setTimeout(function(){
                $(navMain).addClass(navActive).removeAttr('style');
            },250);
        }
    });

    $('.grid-intro').owlCarousel({
        items: 1,
        animateOut: 'slideOutDown',
        animateIn: 'flipInX',
        smartSpeed: 450,
        loop: true,
        center: true,
        nav: true,
        navText: ["<i class='fa fa-chevron-left'></i>","<i class='fa fa-chevron-right'></i>"]

    });
});
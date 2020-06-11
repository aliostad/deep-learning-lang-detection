/**
 * Created by lmarkus on 1/10/14.
 */
$(function () {
    $(window).resize(function () {
        if ($(window).width() > 640) {
            $('.nav').removeClass('tc').show();
            $('.toggler').hide();
        }
        else {
            $('.nav').hide();
            $('.toggler').show();
        }
    });

    $('.toggler').click(function () {
        var nav = $('.nav');
        if (nav.hasClass('tc')) {
            nav.toggle();
        }
        else {
            nav.addClass('tc');
        }
    })

    $('.nav li').click(function () {
        if ($(window).width() < 640) {
            $('.nav').hide();
        }
    });
});
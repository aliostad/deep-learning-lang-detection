$(document).scroll(function () {
    var position = $(window).scrollTop();
    var navEl = $('.nav-wrapper');

    if (position >= 300) 
    {
        if (!navEl.hasClass('nav-wrapper-black'))
            navEl.addClass('nav-wrapper-black');
    } 
    else 
    {
        if (navEl.hasClass('nav-wrapper-black'))
            navEl.removeClass('nav-wrapper-black');
    }
});

$(document).scroll(function () {
    var position = $(window).scrollTop();
    var navEl = $('.nav').first();

    if (position >= 700 & position <= 1538) 
    {
        if (!navEl.hasClass('nav-yellow'))
            navEl.addClass('nav-yellow');
    } 
    else 
    {
        if (navEl.hasClass('nav-yellow'))
            navEl.removeClass('nav-yellow');
    }
});

$(document).scroll(function () {
    var position = $(window).scrollTop();
    var navEl = $('.nav').first().next();

    if (position >= 1539 & position <= 2834) {
        $('about')
        if (!navEl.hasClass('nav-yellow'))
            navEl.addClass('nav-yellow');
    } else {
        if (navEl.hasClass('nav-yellow'))
            navEl.removeClass('nav-yellow');
    }
});

$(document).scroll(function () {
    var position = $(window).scrollTop();
    var navEl = $('.nav').first().next().next();

    if (position >= 2835 & position <= 5012) {
        if (!navEl.hasClass('nav-yellow'))
            navEl.addClass('nav-yellow');
    } else {
        if (navEl.hasClass('nav-yellow'))
            navEl.removeClass('nav-yellow');
    }
});


$(document).scroll(function () {
    var position = $(window).scrollTop();
    var navEl = $('.nav').first().next().next().next();

    if (position >= 5013 & position <= 6267) {

        if (!navEl.hasClass('nav-yellow'))
            navEl.addClass('nav-yellow');
    } else {
        if (navEl.hasClass('nav-yellow'))
            navEl.removeClass('nav-yellow');
    }
});

$(document).scroll(function () {
    var position = $(window).scrollTop();
    var navEl = $('.nav').last();

    if (position > 6267) {
        if (!navEl.hasClass('nav-yellow'))
            navEl.addClass('nav-yellow');
    } else {
        if (navEl.hasClass('nav-yellow'))
            navEl.removeClass('nav-yellow');
    }
});

var href;
$(document).ready(function(){
    $(".scroll").click(function() {
        var a = $(this).attr('href');
        href = $(a).offset().top;
    });

    $('.scroll').click(function(){
        $('html, body').animate({scrollTop:href}, 2000);
        return false;
    });
});

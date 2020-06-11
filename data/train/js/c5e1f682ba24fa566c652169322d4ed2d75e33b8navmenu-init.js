
// Mobile Navigation
$('.mobile-toggle').click(function() {
    if ($('.main-nav').hasClass('open-nav')) {
        $('.main-nav').removeClass('open-nav');
        $('.masthead').removeClass('revealed');
    } else {
        $('.main-nav').addClass('open-nav');
        $('.masthead').addClass('revealed');
    }
});

// Mobile Navigation
$('.mobile-toggle').mouseenter(function() {
    if ($('.main-nav').hasClass('open-nav')) {
        $('.main-nav').removeClass('open-nav');
        $('.masthead').removeClass('revealed');
    } else {
        $('.main-nav').addClass('open-nav');
        $('.masthead').addClass('revealed');
    }
});

// $('.main-nav li a').click(function() {
//     if ($('.main-nav').hasClass('open-nav')) {
//         $('.navigation').removeClass('open-nav');
//         $('.main-nav').removeClass('open-nav');
//     }
// });

$('.mastwrap').click(function(){
        $('.main-nav').removeClass('open-nav');
        $('.masthead').removeClass('revealed');
})

    //Navigation Sub Menu Triggering
    $('.trigger-sub-nav').click(function(){
        $('.sub-nav').slideUp('fast');
        $(this).find('.sub-nav').slideDown('slow');
    })

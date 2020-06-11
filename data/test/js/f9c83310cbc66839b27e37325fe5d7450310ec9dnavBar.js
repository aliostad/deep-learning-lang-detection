function toggleNav() {
    if ($('#site-wrapper').hasClass('show-nav')) {
        // Do things on Nav Close
        $('#site-wrapper').removeClass('show-nav');
        $('.toggle-nav').text("☰");
    } else {
        // Do things on Nav Open
        $('#site-wrapper').addClass('show-nav');
        $('.toggle-nav').text("X");
        $('#main').css( 'transform','translateX(80px)');
    }

    //$('#site-wrapper').toggleClass('show-nav');
}


$(function() {
    $('.toggle-nav').click(function() {
        // Calling a function in case you want to expand upon this.
        toggleNav();
    });
});

$(function() {
  var nav_bar          = $('#nav_floater')[0],
      nav_location     = nav_bar.getBoundingClientRect(),
      nav_top_original = nav_location.bottom - nav_location.height,
      nav_top          = nav_location.bottom - nav_location.height;

  $(window).scroll(function() {
    nav_location = nav_bar.getBoundingClientRect();
    nav_top = nav_location.bottom - nav_location.height;

    if (nav_top < 0) {
      if (!$(nav_bar).hasClass('follow')) {
        // Reset the original location as we transition to floating,
        // in case a media query has changed it.
        nav_top_original = $(nav_bar).offset().top;
        $(nav_bar).addClass('follow');
        $('body').css({ paddingTop: nav_location.height + 'px' });
      }
    } else if(  $(nav_bar).hasClass('follow')
             && $(window).scrollTop() < nav_top_original
    ) {
      $(nav_bar).removeClass('follow');
      $('body').css({ paddingTop: 0 });
    }
  });
});

$(document).ready(function() {
  $(function() {
    var navTop = $('nav').offset().top;

    function stickNav() {
      var currentScroll = $(window).scrollTop(); // our current vertical position from the top
      if (currentScroll > navTop) {
        $(window).scrollTop = currentScroll;
        $('nav').not('.admin-navbar').css({
          'position': 'fixed',
          'top': 0,
          'width': '100%'
        });
      } else {
        $('nav').not('.admin-navbar').css({
          'position': 'relative',
          'top': 0,
          'width': '100%'
        });
      }
    }
    stickNav();
    $(window).scroll(function() {
      stickNav();
    });
  });
});

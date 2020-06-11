(function() {
  function setUpSmoothScroll() {
    $("#header nav").visualNav({
      selectedAppliedTo: "a",
      selectedClass: "current"
    });
  }

  function setUpMobileMenu() {
    var nav = $('#header nav')
      , hideTriggers = $('#content, #header nav a');

    var hideNav = function() {
      nav.slideUp(100);
    };

    $('#expand').on('click', function(e) {
      e.preventDefault();
      nav.slideToggle(100);
      hideTriggers.one('click', hideNav);
    });

    // in case the window is made larger after the
    // nav has been hidden, show the nav
    $(window).on('resize', function() {
      if ($(window).width() > 767) {
        nav.show();
        hideTriggers.off('click', hideNav);
      }
    });
  }

  App.setUpNav = function() {
    setUpSmoothScroll();
    setUpMobileMenu();
  }
})();

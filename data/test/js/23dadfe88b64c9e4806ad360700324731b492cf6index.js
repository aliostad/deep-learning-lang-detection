(function() {
  var $window = $(window);
  var $nav = $(document.getElementsByTagName('nav'));
  var NAV_HEIGHT = $nav.height();
  var initialNavTop = $nav[0] &&
    ($nav[0].getBoundingClientRect().top + window.scrollY);

  function navShouldBeFixed() {
    if (stickySupported() || initialNavTop == null)
      return false;
    else
      return state().scroll >= initialNavTop;
  }

  function navMenuShouldOpenUp() {
    var bounds = $nav[0] && $nav[0].getBoundingClientRect();

    if (!bounds)
      return true;

    if (bounds.top == null || state().vh == null)
      return true;

    return bounds.top > state().vh / 2;
  }

  function fixNav(shouldFix) {
    if (shouldFix) {
      $nav.find('.nav-menu').addClass('no-transition');
      $nav.addClass('fixed');
      setTimeout(function() {
        $nav.find('.nav-menu').removeClass('no-transition');
      }, 0);
    } else {
      $nav.find('.nav-menu').addClass('no-transition');
      $nav.removeClass('fixed');
      $nav.find('.nav-menu')[0].getBoundingClientRect();
      setTimeout(function() {
        $nav.find('.nav-menu').removeClass('no-transition');
      }, 0);
    }
  }

  function setOpeningDirectionDownward(downward) {
    if (downward) {
      $nav.find('.nav-menu').addClass('no-transition');
      $nav.addClass('open-downward');
      setTimeout(function() {
        $nav.find('.nav-menu').removeClass('no-transition');
      }, 0);
    } else {
      $nav.find('.nav-menu').addClass('no-transition');
      $nav.removeClass('open-downward');
      $nav.find('.nav-menu')[0].getBoundingClientRect();
      setTimeout(function() {
        $nav.find('.nav-menu').removeClass('no-transition');
      }, 0);
    }
  }

  state.onchange(function(event, current, previous) {
    if (current.scroll != previous.scroll || current.vh != previous.vh)
      state({
        fixed: navShouldBeFixed(),
        navMenuOpensUp: navMenuShouldOpenUp()
      });

    if (current.fixed != previous.fixed)
      fixNav(current.fixed);

    if (current.navOpen !== previous.navOpen)
     if (current.navOpen)
       $nav.addClass('open');
     else
       $nav.removeClass('open');

    if (current.navMenuOpensUp != previous.navMenuOpensUp)
      if (current.navMenuOpensUp)
        setOpeningDirectionDownward(false);
      else
        setOpeningDirectionDownward(true);
  });

  $window.on('resize orientationchange', function() {
      state({vh: $window.height()});
    })
    .on('scroll', function() {
      state({scroll: window.scrollY});
    });

  $(document.body).on('click', '.hamburger', function() {
    state({navOpen: !state().navOpen});
  });

  state({
    vh: $window.height(),
    scroll: window.scrollY
  });
})();

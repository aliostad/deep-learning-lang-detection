$.fn.navigationController = function() {
  var nav = $.fn.navigationController;

  var $el = $(this);
  var $desktopNav = $el.find("nav.navigation");
  var $mobileNav = $el.find("nav.mobile-navigation");
  var $currentNav = $desktopNav;

  var navVisible = true;



  nav.init = function() {
    nav.addBindings();
    nav.addKeyboardBindings();
  };

  nav.addBindings = function() {
    $el.on("mouseenter", "nav", (function(e) {
      if ($currentNav === $desktopNav) {
        nav.showCurrentNavigation();
      }
    }));

    $el.on("click", ".nav-expand", (function(e) {
      if ($currentNav === $mobileNav && navVisible === false) {
        nav.showCurrentNavigation();
      } else if ($currentNav === $mobileNav && navVisible === true) {
        nav.hideCurrentNavigation();
      }
    }));
  };

  nav.addKeyboardBindings = function() {
    var spacebar = 32;
    var one = 49;
    var two = 50;
    var three = 51;
    var four = 52;
    var five = 53;

    $("body").keyup(function(e) {
      if (!$(".age-gate").hasClass("is-active") && !$(".modal-overlay").hasClass("active") && !$("body").hasClass("find-casa-noble") && !$("body").hasClass("mobile")) {
        switch (e.keyCode) {
          case spacebar:
            nav.showCurrentNavigation();
            break;
          case one:
            window.location.pathname = $(".navlinks .link a").eq(0).attr("href");
            break;
          case two:
            window.location.pathname = $(".navlinks .link a").eq(1).attr("href");
            break;
          case three:
            window.location.pathname = $(".navlinks .link a").eq(3).attr("href");
            break;
          case four:
            window.location.pathname = $(".navlinks .link a").eq(4).attr("href");
            break;
        }
      }
    });
  };

  nav.showCurrentNavigation = function() {
    if (!navVisible) {
      $currentNav.addClass("is-visible");
      navVisible = true;
    }
  };

  nav.hideCurrentNavigation = function() {
    if (navVisible) {
      $currentNav.removeClass("is-visible");
      navVisible = false;
    }
  };

  nav.activateDesktopNavigation = function() {
    if ($currentNav != $desktopNav) {
      $currentNav.removeClass("is-active");
      $currentNav.removeClass("is-visible");
      $currentNav = $desktopNav;
      $currentNav.addClass("is-active");
      $currentNav.addClass("is-visible");
      navVisible = true;
    }
  };

  nav.activateMobileNavigation = function() {
    if ($currentNav != $mobileNav) {
      $currentNav.removeClass("is-active");
      $currentNav.removeClass("is-visible");
      $currentNav = $mobileNav;
      $currentNav.addClass("is-active");
      navVisible = false;
    }
  };

  nav.isMobileNav = function() {
    return $currentNav === $mobileNav;
  };

  nav.isDesktopNav = function() {
    return $currentNav === $desktopNav;
  };
}
;

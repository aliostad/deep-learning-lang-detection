(function() {
  $(document).ready(function() {
    var $nav, $navSpacer, $subnav;
    $nav = $(".sticky-nav");
    $subnav = $(".sticky-subnav");
    $navSpacer = $("<div />", {
      "class": "nav-drop-spacer",
      height: $nav.outerHeight()
    });
    if ($nav.length && $subnav.length) {
      return $(window).scroll(function() {
        if (!$nav.hasClass("nav-fix") && $(window).scrollTop() > $nav.offset().top) {
          $nav.before($navSpacer);
          $nav.addClass("nav-fix");
          return $subnav.addClass("subnav-fix");
        } else if ($nav.hasClass("nav-fix") && $(window).scrollTop() < $navSpacer.offset().top) {
          $nav.removeClass("nav-fix");
          $subnav.removeClass("subnav-fix");
          return $navSpacer.remove();
        }
      });
    } else {
      return $(window).scroll(function() {
        if (!$nav.hasClass("nav-fix") && $(window).scrollTop() > $nav.offset().top) {
          $nav.before($navSpacer);
          return $nav.addClass("nav-fix");
        } else if ($nav.hasClass("nav-fix") && $(window).scrollTop() < $navSpacer.offset().top) {
          $nav.removeClass("nav-fix");
          return $navSpacer.remove();
        }
      });
    }
  });

}).call(this);

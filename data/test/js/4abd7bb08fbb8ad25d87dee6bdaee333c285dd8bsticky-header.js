// ========================================================
// 
// sticky header 
//
// ========================================================

// variables
var $window = $(window), // window object
  $nav = $("#nav-wrapper"), // navigation bar
  $navSpacer = $("<div />", { // nav place holder
    "id": "navPlaceHolder"
  });

// scroll event listener
$window.scroll(stickyNavHandler);

// stickyNav Handler function
function stickyNavHandler() {
  if (!$nav.hasClass("stick") && $window.scrollTop() > $nav.offset().top) {
    stickNav();
  } else if ($nav.hasClass("stick") && $window.scrollTop() < $navSpacer.offset().top) {
    unstickNav();
  }
};

// this function sticks the nav to the top of the window
function stickNav() {
  var navHeight = $nav.css("height");

  $navSpacer.css("height", navHeight);
  $nav.before($navSpacer);
  $nav.addClass("stick");
  $nav.removeClass("unstick");
};

// this function unsticks the nav to the top of the window
function unstickNav() {
  $nav.addClass("unstick");
  $nav.removeClass("stick");
  $navSpacer.remove();
};

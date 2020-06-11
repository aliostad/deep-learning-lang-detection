var GlobalNav;

GlobalNav = (function() {
  var $button, $content, $nav, $overlay, showFlg, toggleNav;

  $nav = $('#globalNav');

  $overlay = $('#globalOverlay');

  $content = $('#globalContent');

  $button = $('#showGlobalNav');

  showFlg = false;

  toggleNav = function() {
    if (showFlg) {
      showFlg = false;
      $content.stop().animate({
        left: -225
      }, 200, function() {
        $nav.stop().hide();
      });
    } else {
      showFlg = true;
      $nav.stop().show();
      $content.stop().animate({
        left: 0
      }, 200, function() {});
    }
  };

  function GlobalNav() {
    $button.on('click', function(e) {
      e.preventDefault();
      toggleNav();
      return false;
    });
    $overlay.on('click', function() {
      toggleNav();
    });
    $(window).on('touchmove scroll', function(e) {
      if (showFlg) {
        e.preventDefault;
        return false;
      }
    });
    return;
  }

  return GlobalNav;

})();

$(function(jQuery) {
  var globalNav;
  globalNav = new GlobalNav();
});

$(function() {
  var showAfterTargets = $("[data-show-after]");
  var showAfterElements = [];

  showAfterTargets.each(function() {
    var showAfterSelector = $(this).data("show-after");
    showAfterElements.push({ target: $(this), after: $(showAfterSelector) });
  });

  $(window).scroll(function() {
    for (var i in showAfterElements) {
      if ($(window).scrollTop() >= showAfterElements[i].after.offset().top) {
        showAfterElements[i].target.fadeIn();
      } else {
        showAfterElements[i].target.fadeOut();
      }
    }
  });
});

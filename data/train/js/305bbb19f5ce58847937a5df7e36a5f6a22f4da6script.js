var nav
var navAvailable = true;
$(document).ready(function() {
  $(".navElement:not(.current)").on("click", function() {
    if(navAvailable) {
      navAvailable = false;
      var navEle = $(this);
      var navWin = $($(this).data("window-class"));
      console.log(navEle);
      console.log(navWin);

      $(this).addClass("noScroll");
      $(".appWindow").addClass("hidden");
      $(".navElement").removeClass("current");

      $(document).delay(250).queue(function() {
        $(".appWindow").addClass("noDisplay");
        navEle.removeClass("noScroll");
        navWin.removeClass("noDisplay");
        navWin.removeClass("hidden");
        navEle.addClass("current");
        $(this).dequeue();
      }).delay(250).queue(function() {
        navAvailable = true;
        $(this).dequeue();
      });
    }
  });
});
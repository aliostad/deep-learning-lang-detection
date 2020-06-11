function navFix() {
  var b = $("body");

	if ($(window).width() < 480) {
    if (!b.hasClass("nav--on")) {
      b.addClass("nav--off");
    }
	} else {
    b.removeClass("nav--off nav--on");
  };

  $("#nav-trigger").click(function(){
    if (b.hasClass("nav--off")) {
      b.removeClass("nav--off");
      setTimeout(function() {
        b.addClass("nav--on");
      }, 100);
    } else if (b.hasClass("nav--on")) {
      b.removeClass("nav--on");
      setTimeout(function() {
        b.addClass("nav--off");
      }, 300);
    };
  });

  $(window).scroll(function(){
    if (b.hasClass("nav--on")) {
      b.removeClass("nav--on");
      setTimeout(function() {
        b.addClass("nav--off");
      }, 300);
    };
  })
}

$(document).ready(function() {
  navFix();
});

$(window).resize(function() {
  navFix();
});
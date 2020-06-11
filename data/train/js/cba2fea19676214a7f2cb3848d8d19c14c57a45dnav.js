function nav_resize() {
  if ($(window).width() < 550) {
    $("nav").hide();
    $("#nav-expand").show();
    nav_toggle_change_button();
  } else {
    $("nav").show();
    $("#nav-expand").hide();
  }
}

function nav_toggle_change_button() {
  var nav_toggle = $('#nav-expand > i');
  if ($('nav').is(':visible')) {
    nav_toggle.addClass('fa-times');
    nav_toggle.removeClass('fa-bars');
  } else {
    nav_toggle.addClass('fa-bars');
    nav_toggle.removeClass('fa-times');
  }
}

$(window).resize(nav_resize);

$("#nav-expand").click(function() {
  $('nav').slideToggle(nav_toggle_change_button);
});

nav_resize();


$(document).ready(function(){
    var body = $("body"),
         navOverlay = $(".overlay"),
         nav = $("nav#off-canvas-nav"),
         navIcon = $("#nav-icon"),
         subMenu = $("li.menu-item-has-children > a");
    navIcon.click(function(e) {
        e.preventDefault();
        $(this).toggleClass("open");
        body.toggleClass("nav-open");
        nav.toggleClass("open");
    });
    navOverlay.click(function() {
        navIcon.removeClass("open");
        body.removeClass("nav-open");
        nav.removeClass("open");
    });
    subMenu.click(function(drop) {
        drop.preventDefault();
        $(this).parent().toggleClass("open");
    });
  });
/*
-------------------------------------------
  STICKY NAVIGATION
-------------------------------------------
*/
jQuery(function($) {
  $(function() {

    var nav_container = $(".secondary-nav-container");
    var nav = $(".secondary-nav-container nav");
    var logo = $(".secondary-nav-container .logo");
    //var nav_button = $(".secondary-nav-container .hidden");

    var top_spacing = 0;

    nav_container.waypoint({
      handler: function(event, direction) {

        if (direction == 'down') {
          if (matchMedia('only screen and (min-width: 1000px)').matches) {
            nav_container.css({ 'height':nav.outerHeight() });
            nav.addClass("sticky").css("top", 0);
            nav.parent().addClass("nav-scroll");
            logo.fadeIn();
            //nav_button.fadeIn("hidden");
            //nav_button.removeClass("hidden");
          }

        } else {
          nav_container.css({ 'height':'auto' });
          nav.removeClass("sticky");
          nav.parent().removeClass("nav-scroll");
          logo.fadeOut();
        }
      }
    });

    var sections = $("section");
    var navigation_links = $("nav a");

    sections.waypoint({
      handler: function(event, direction) {

        var active_section;
        active_section = $(this);
        if (direction === "up") active_section = active_section.prev();

        var active_link = $('nav a[href="#' + active_section.attr("id") + '"]');
        navigation_links.removeClass("selected");
        active_link.addClass("selected");

      },
      offset: '95%'
    }, function(){ $.waypoints("refresh"); });
  });

  });


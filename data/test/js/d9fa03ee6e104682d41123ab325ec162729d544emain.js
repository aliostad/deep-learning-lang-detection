$(document).ready(function() {

  // sticky header

  $('body > header > nav').sticky();

  // scroll to content

  $('header nav ul').onePageNav({
    filter: ':not(.external)',
    currentClass: 'current',
    scrollOffset: 60,
    scrollSpeed: 600,
    scrollThreshold: 0.5
  });

  // hamburger menu

  var body = $('body');
  var nav_toggler = $('a.hamburger');
  var nav_links = $('header nav ul a');

  var toggle_nav = function(event) {
    event.preventDefault();
    body.toggleClass('active_nav');
  }

  var hide_nav = function() {
    body.removeClass('active_nav');
  }

  nav_toggler.on('click', toggle_nav);

  $(window).on('scroll', hide_nav);

  nav_links.on('click', hide_nav);


});

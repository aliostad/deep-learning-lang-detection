$(document).ready(function() {

  // cache nav object
  var $nav = $('nav');

  // fancybox setup
  $('.fancybox').fancybox({
    beforeShow: function() { $nav.removeClass('active') },
    afterClose: function() { $nav.addClass('active') }
  });

  // Initiate Navigation Animation Domination
  var setActiveNav = function(pos) {
    $nav.find('a').removeClass('active')
                  .filter(':eq(' + pos + ')')
                  .addClass('active');
  }

  $('#nav-trigger').waypoint({
    handler: function(dir) {
      dir === 'down' ?
        $nav.addClass('active'):
        $nav.removeClass('active');
    }
  });

  $('.nav-services').waypoint({
    handler: function(dir) {
      dir === 'down' ?
        setActiveNav(1):
        $nav.find('a').removeClass('active');
    }
  });

  $('.nav-about').waypoint({
    handler: function(dir) {
      dir === 'down' ?
        setActiveNav(2):
        setActiveNav(1);
    }
  });

  $('.nav-portfolio').waypoint({
    handler: function(dir) {
      dir === 'down' ?
        setActiveNav(3):
        setActiveNav(2);
    }
  });

  $('.nav-clients').waypoint({
    handler: function(dir) {
      dir === 'down' ?
        setActiveNav(4):
        setActiveNav(3);
    }
  });

  $('.nav-contact').waypoint({
    handler: function(dir) {
      dir === 'down' ?
        setActiveNav(5):
        setActiveNav(4);
    }
  });

});

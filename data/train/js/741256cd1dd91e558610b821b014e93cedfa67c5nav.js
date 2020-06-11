$(document).ready(function () {
  
   // var $window = $(window),
   //     $stickyEl = $('.secondary-nav'),
   //     elTop = $stickyEl.offset().top - 5;

   // $window.scroll(function() {
   //      $stickyEl.toggleClass('second-nav-scroll', $window.scrollTop() > elTop);
   //  });

  var stickySidebar = $('.secondary-nav').offset().top;

  $(window).scroll(function() {  
      if ($(window).scrollTop() > stickySidebar) {
          $('.secondary-nav').addClass('second-nav-scroll');
          $('.second-nav-fix').addClass('show-nav-fix');
      }
      else {
          $('.secondary-nav').removeClass('second-nav-scroll');
          $('.second-nav-fix').removeClass('show-nav-fix');
      }  
  });



});


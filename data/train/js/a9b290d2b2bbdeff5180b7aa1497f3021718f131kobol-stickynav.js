jQuery(function($) {
  $(document).ready(function() {
     var $ph = $('#nav-placeholder'),
         $nav = $('#nav-wrap', $ph),
         navOffset = $nav.offset();
     
     $ph.css({
       'height': $nav.height()
     });    
     
     $nav.addClass('sticky-nav');
     
     $(window).scroll(function(){
       var topOffset;
       
       if ( $('body').hasClass('admin-bar') ) {
         topOffset = navOffset.top - $('#wpadminbar').height();
       } else {
         topOffset = navOffset.top;
       }
     
       if ( $(window).scrollTop() >= topOffset ) {
         $nav.addClass('stuck');
       } else {
         $nav.removeClass('stuck');
       }
     });
  });
});
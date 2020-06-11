nav.directive('navSettings', [function() {
  return {
    restrict: 'A',
    link: function($scope, element, attrs) {
      
      var windowHeight = $(window).height(),
          siteNav = $('#site-nav');
      
      siteNav.css('height', windowHeight + 'px');
      
      element.on('click', function() {
        
          var posLeft, 
              navWidth = siteNav.width();
        
          if (element.hasClass('x')) {
            element.removeClass('x');
            posLeft = -navWidth;
          }
          else {
            element.addClass('x');
            posLeft = 0;
          }
        
          siteNav.stop().animate({
            left: posLeft
          });
      });
    }
  }
}]);
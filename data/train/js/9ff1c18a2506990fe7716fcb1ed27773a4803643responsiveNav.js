var $ = require('jquery');

var isShowingResponsiveNav = false;
var isAnimatingNav = false;

var responsiveNavButtonClick = function() {
  if(isAnimatingNav)
  {
    return;
  }
  if(!isShowingResponsiveNav) {
    isAnimatingNav = true;
    $('#responsive-nav-list').slideDown(500, function() {
      isShowingResponsiveNav = true;
      isAnimatingNav = false;
    });
    $('.caret').addClass('caret-down');
  } else {
    isAnimatingNav = true;
    $('#responsive-nav-list').slideUp(500, function() {
      isShowingResponsiveNav = false;
      isAnimatingNav = false;
    }); 
    $('.caret').removeClass('caret-down');
  }
};
    
$(function() {
  $('#responsiveNavButton').click(responsiveNavButtonClick);
});
    
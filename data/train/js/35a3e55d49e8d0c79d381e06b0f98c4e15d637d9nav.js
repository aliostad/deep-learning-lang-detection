$(function(){
  var $sgNav = $('.sg-nav');
  var $sgNavToggle = $sgNav.find('.sg-nav--toggle');

  $sgNav.height($(window).height());

  $sgNavToggle.click(function(){
    var currentImage = $sgNavToggle.children('img').attr('src');
    $sgNav.toggleClass('sg-nav_hidden');
    console.log(currentImage);
    currentImage = currentImage === '/styleguide/images/angle-double-left.svg' ? '/styleguide/images/angle-double-right.svg' : '/styleguide/images/angle-double-left.svg';
    $sgNavToggle.children('img').attr('src', currentImage);
    console.log('Step');
  })
});
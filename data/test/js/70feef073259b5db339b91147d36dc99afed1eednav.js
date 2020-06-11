$(function() {
  
  var $mainNav = $('.main-nav'),
      $navOpener = $('.nav-toggle'),
      $navCloser = $mainNav.find('.label'),
      $itemWithChild = $mainNav.find('.menu-item-has-children > a');

  function openNav(e) {
    e.preventDefault();
    $mainNav.addClass('open');
  }

  function closeNav(e) {
    e.preventDefault();
    $mainNav.removeClass('open');
  }

  function toggleChild(e) {
    e.preventDefault();
    var $target = $(e.target).closest('.menu-item');
    var navIsOpen = $target.hasClass('open');
    if(navIsOpen) {
      closeChild($target);
    } else {
      openChild($target);
    }
  }

  function openChild($el) {
    $el.addClass('open');
  }

  function closeChild($el) {
    $el.removeClass('open');
  }

  $navOpener.on('click', openNav);
  $navCloser.on('click', closeNav);
  $itemWithChild.on('click', toggleChild);
}());

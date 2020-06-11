jQuery(function( $ ){

  var $navP = $(".nav-primary");
  var $navS = $(".nav-secondary");
  var $navM = $('<nav class="nav-mobile" role="navigation itemscope="itemscope" itemtype="http://schema.org/WPHeader"></nav>');
  var $menuP = $(".menu-primary");
  var $menuS = $(".menu-secondary");
  var $toggle = $('<div class="menu-toggle"></div>');

  $navM.appendTo('.site-header>.wrap').before($toggle);
  $(".menu-toggle").click(function(){
    $($navM).slideToggle();
  });
  
  $(".menu-item-has-children .sub-menu").before('<div class="sub-menu-toggle"></div>');

  $(".sub-menu-toggle").click(function(){
    var menuDrop = $(this).parent().children('.sub-menu:first');
    $(this).toggleClass("menu-open");
    menuDrop.slideToggle();
  });

  function fancyNav(){
    var winW = window.innerWidth;
    var appended = false;
    if( winW < 800 && !appended ) {
      appended = true;
      $($menuP).appendTo($navM);
      $($menuS).appendTo($navM);
      $navP.detach();
      $navS.detach();
    } else {
      appended = false;
      $navP.appendTo('.site-header>.wrap');
      $navS.insertBefore('.site-inner');
      $menuP.appendTo($navP);
      $menuS.appendTo('.nav-secondary>.wrap');
      $($navP).removeAttr("style");
    }
  }
  
  fancyNav();

  $(window).resize(function(){
    fancyNav();
  });
});
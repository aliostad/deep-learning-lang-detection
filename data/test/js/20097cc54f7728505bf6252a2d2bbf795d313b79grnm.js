jQuery(function( $ ){

  var $navP = $(".nav-primary");
  var $navS = $(".nav-secondary");
  var $navM = $('<nav class="nav-mobile" role="navigation itemscope="itemscope" itemtype="http://schema.org/WPHeader"></nav>');
  var $menuH = $(".nav-header>.menu");
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

  function mmNav(){
    var winW = window.innerWidth;
    if( winW < 840 ) {
      $($menuH).appendTo($navM);
      $($menuP).appendTo($navM);
      $($menuS).appendTo($navM);
      $navP.detach();
      $navS.detach();
    } else {
      $navP.insertBefore('.site-inner');
      $navS.insertBefore('.site-inner');
      $menuH.appendTo('.nav-header');
      $menuP.appendTo('.nav-primary>.wrap');
      $menuS.appendTo('.nav-secondary>.wrap');
    }
  }

  mmNav();

  $(window).resize(function(){
    mmNav();
  });
});
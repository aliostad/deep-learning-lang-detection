$(function() {
  var navPosition = $('#nav-bar').offset().top -10;
  var navBar = document.getElementById('nav-bar');
  var header = document.getElementById('header');

  function navControl() {
    var currentScroll = $(document).scrollTop();
    if (currentScroll >= navPosition) {
      navBar.classList.add('fixed-nav');
      header.classList.add('expand-header');
    } else {
      navBar.classList.remove('fixed-nav');
      header.classList.remove('expand-header');
    }  
  }

  $(window).scroll(navControl);
});

// 配合navbar.css和navbar.html，实现简单的导航条效果
// 随页面动态变化的导航条

(function($){
  var navElem = $('.nav');
  var bodyElem = $('body');

  // updateNavPos函数实现滚动时导航条隐藏，页面回到顶部导航条出现
  function updateNavPos() {
    if (bodyElem.scrollTop() === 0) {
      navElem.removeClass('nav--off');
    } else {
      navElem.addClass('nav--off');
    }
  }

  // 监听事件
  $(window).on('scroll', function() {
    window.requestAnimationFrame(updateNavPos);
  })
  navElem.on('mouseover', function() {
    navElem.removeClass('nav--off');
  });
})($);